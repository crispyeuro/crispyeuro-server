'use strict';

import { readFile } from 'fs/promises';
import pg from 'pg';
import express from 'express';
import cookieParser from 'cookie-parser';

const app = express();

const databaseClient = new pg.Client();

async function test() {
    await databaseClient.connect();
    await loadDatabaseCreationCode(databaseClient);
}

async function loadDatabaseCreationCode(databaseClient) {
    const code = await readDatabaseCreationCode();
    await databaseClient.query(code);
}

async function readDatabaseCreationCode() {
    const buffer = await readFile('./scripts/database.sql');
    const code = buffer.toString();
    return code;
}

test();

app.use(express.urlencoded({
    extended: true
}));

app.use(cookieParser());

app.use('/scripts', express.static('../crispyeuro-client/scripts'));
app.use('/static', express.static('../crispyeuro-client/static'));
app.use('/styles', express.static('../crispyeuro-client/styles'));

app.get('/', (req, res) => {
    res.redirect('/static');
})

app.get('/api/first-row', (serverRequest, serverResponse) => {
    databaseClient.query('SELECT * FROM coin WHERE coin_id = $1', [1], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    })
});

app.get('/api/lala', (serverRequest, serverResponse) => {
    const { coin_id } = serverRequest.query;
    databaseClient.query('SELECT coin.*, coin_mintage.coin_mintage_id, coin_mintage.mintage_total, coin_mintage.uncirculated, coin_mintage.brilliant_uncirculated, coin_mintage.proof, coin_mintage.mintmark, coin_mintage.mint, coin_mintage.issue_date, coin_mintage.mintage_description FROM coin LEFT OUTER JOIN coin_mintage ON coin.coin_id = coin_mintage.coin_id WHERE coin.coin_id = $1;', [coin_id], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/commemorativeCountryRequest', (serverRequest, serverResponse) => {
    const { issue_year = null, country = null, coin_type = null } = serverRequest.query;
    let coin_type_common = "commemorative_common";
    const accessToken = serverRequest.cookies['access-token'];
    if (issue_year === null && country !== null && coin_type !== null) {
        databaseClient.query('SELECT * FROM get_commemorative_by_country_table($1, $2, $3, $4)', [accessToken, country, coin_type, coin_type_common], (err, databaseResponse) => {
            if (err) {
                console.log(err.stack);
            } else {
                serverResponse.json(databaseResponse.rows);
            }
        });
    }
    if (country === null && issue_year !== null && coin_type !== null) {
        databaseClient.query('SELECT * FROM get_commemorative_by_year_table($1, $2, $3)', [accessToken, issue_year, coin_type], (err, databaseResponse) => {
            if (err) {
                console.log(err.stack);
            } else {
                serverResponse.json(databaseResponse.rows);
            }
        });
    }
});

app.get('/api/countryRequest', (serverRequest, serverResponse) => {
    const { country } = serverRequest.query;
    const accessToken = serverRequest.cookies['access-token'];
    databaseClient.query('SELECT * FROM get_countrycard_table($1, $2)', [accessToken, country], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/denominationRequest', (serverRequest, serverResponse) => {
    const { denomination } = serverRequest.query;
    const accessToken = serverRequest.cookies['access-token'];
    databaseClient.query('SELECT * FROM get_denominationcard_table($1, $2)', [accessToken,  denomination], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/indexCoinsRequest', (serverRequest, serverResponse) => {
    databaseClient.query("SELECT * FROM coin ORDER BY coin.country, coin.issue_year ASC;", (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.listen(8080, () => {
    console.log('server is running...');
});

app.post('/signUp', (serverRequest, serverResponse) => {
    const username = serverRequest.body.username;
    const password = serverRequest.body.password;
    const email = serverRequest.body.email;
    databaseClient.query('SELECT * FROM sign_up($1, $2, $3)', [username, password, email], (error, databaseResponse) => {
        if (error) {
            serverResponse.json({ error: error.message });
        } else {
            performLogin(serverResponse, databaseResponse);
            serverResponse.sendStatus(200);
        }
    });
});

app.post('/login', (serverRequest, serverResponse) => {
    const username = serverRequest.body.username;
    const password = serverRequest.body.password;
    databaseClient.query('SELECT * FROM login($1, $2)', [username, password], (error, databaseResponse) => {
        if (error) {
            serverResponse.json({ error: error.message });
        } else {
            performLogin(serverResponse, databaseResponse);
            serverResponse.redirect('/static/index.html');
        }
    });
});

function performLogin(serverResponse, databaseResponse) {
    const session = databaseResponse.rows[0];
    const timestamp = session.expiration_date.getTime();
    const accessToken = session.access_token;
    serverResponse.cookie('access-token', accessToken, { expire: timestamp, sameSite: true });
}

app.get('/logout', function (serverRequest, serverResponse) {
    const accessToken = serverRequest.cookies['access-token'];
    databaseClient.query('SELECT logout($1)', [accessToken], (error) => {
        if (error) {
            console.log(error);
        };
    });
    serverResponse.cookie('access-token', '', { expires: new Date(), sameSite: true });
    serverResponse.redirect('/static/login.html');
});

/*Get username*/
app.get('/api/layoutUsername', (serverRequest, serverResponse) => {
    let access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT username FROM user_account INNER JOIN user_session ON user_account.user_id = user_session.user_id WHERE user_session.access_token = $1", [access_token], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

/*Get added coins*/
app.get('/api/layoutAddedCoins', (serverRequest, serverResponse) => {
    let access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT Count(DISTINCT added_coin.coin_id) FROM added_coin INNER JOIN user_session ON user_session.user_id = added_coin.user_id WHERE user_session.access_token = $1;", [access_token], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

/*Get coins amount*/
app.get('/api/coinsAmount', (serverRequest, serverResponse) => {
    databaseClient.query("SELECT Count(*) FROM coin;", (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

/*Get added coins*/
app.get('/api/userAddedCoins', (serverRequest, serverResponse) => {
    let access_token = serverRequest.cookies['access-token'];
    const { coin_id } = serverRequest.query;
    databaseClient.query("SELECT * FROM get_user_added_coins_for_coincard($1, $2);", [access_token, coin_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

/*Update added coin*/
app.post('/addCoin', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    const coinId = serverRequest.body.coinId;
    const addedCoinId = serverRequest.body.addedCoinId;
    const grade = serverRequest.body.grade;
    const value = serverRequest.body.value;
    const amount = serverRequest.body.amount;
    const design = serverRequest.body.design;
    const inSet = serverRequest.body.inSet;
    const comment = serverRequest.body.comment;
    const picturePath = serverRequest.body.picturePath;
    databaseClient.query("SELECT update_coin($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)", [access_token, coinId, addedCoinId, grade, value, amount, design, inSet, comment, picturePath], (error, databaseResponse) => {
        if (error) {
            console.log(error);
        } else {
            serverResponse.sendStatus(200);
        }
    });
});

app.post('/deleteAddedCoin', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    const addedCoinId = serverRequest.body.addedCoinIdToDeleteId;
    databaseClient.query("SELECT delete_coin($1, $2)", [access_token, addedCoinId], (error, databaseResponse) => {
        if (error) {
            console.log(error);
        } else {
            serverResponse.sendStatus(200);
        }
    });
});

app.post('/checkboxAddedCoin', (serverRequest, serverResponse) => {
    const accessToken = serverRequest.cookies['access-token'];
    const addedCoinId = serverRequest.body.addedCoinToSwapId;
    const swapCheckboxValue = serverRequest.body.userCoinSwapAvailable;
    databaseClient.query("SELECT coin_swap_available($1, $2, $3)", [accessToken, addedCoinId, swapCheckboxValue], (error, databaseResponse) => {
        if (error) {
            console.log(error);
        } else {
            serverResponse.sendStatus(200);
        }
    });
});

/*Get added coins to swap*/
app.get('/api/userCoinsToSwapRequest', (serverRequest, serverResponse) => {
    let access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT * FROM get_user_coins_to_swap($1)", [access_token], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

/*Delete added coin from swap availability list*/
app.post('/deleteUserCoinToSwap', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    const addedCoinId = serverRequest.body.addedCoinToSwapId;
    databaseClient.query("SELECT change_coin_to_swap_list($1, $2)", [access_token, addedCoinId], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

/*Add wanted coin*/
app.post('/addWantedCoin', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    const coinId = serverRequest.body.wantThisCoinId;
    console.log(coinId);
    databaseClient.query("SELECT add_to_wanted_coin_table($1, $2);", [access_token, coinId], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

/*Change wanted coin*/
app.post('/changeWantedCoin', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    const coinId = serverRequest.body.wantThisCoinId;
    const grade = serverRequest.body.grade;
    const amount = serverRequest.body.amount;
    const design = serverRequest.body.design;
    const inSet = serverRequest.body.inSet;
    const comment = serverRequest.body.comment;
    databaseClient.query("SELECT change_wanted_coin($1, $2, $3, $4, $5, $6, $7);", [access_token, coinId, grade, amount, design, inSet, comment], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/userWantedCoin$', (serverRequest, serverResponse) => {
    const { coin_id } = serverRequest.query;
    let access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT * FROM get_user_wanted_coin($1, $2)", [access_token, coin_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.post('/deleteWantedCoin', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    const wantedCoinId = serverRequest.body.wantedCoinId;
    databaseClient.query("SELECT delete_wanted_coin($1, $2);", [access_token, wantedCoinId], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/coincardSwapWantedCoins$', (serverRequest, serverResponse) => {
    const { coin_id } = serverRequest.query;
    let access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT * FROM get_coincard_swap_wanted_coins($1, $2)", [access_token, coin_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/getOtherUserCoinsToSwap', (serverRequest, serverResponse) => {
    const { wanted_coin_id } = serverRequest.query;
    databaseClient.query("SELECT * FROM getOtherUserCoinsToSwap($1);", [wanted_coin_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.post('/sendUserOffer', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];

    let coinsToOffer = serverRequest.body.coinsToOffer;
    coinsToOffer = getAnArray(coinsToOffer);

    let coinsToGet = serverRequest.body.coinsToGet;
    coinsToGet = getAnArray(coinsToGet);

    const comment = serverRequest.body.comment;
    const otherUsername = serverRequest.body.otherUserUsername;

    databaseClient.query("SELECT insert_coin_offer($1, $2, $3, $4, $5);", [access_token, coinsToOffer, coinsToGet, comment, otherUsername], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

function getAnArray(object) {
    let coinIdArray = [];
    if (typeof object == 'object') {
        let i;
        for(i = 0; i < object.length; i++) {
            coinIdArray.push(object[i]);
        }
    }
    if (typeof object == 'string') {
        coinIdArray.push(object);
    }
    return coinIdArray;
}

app.get('/api/coincardSwapOfferedCoins$', (serverRequest, serverResponse) => {
    const { coin_id } = serverRequest.query;
    let access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT * FROM get_coincard_swap_offered_coins($1, $2)", [access_token, coin_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/getOtherUserWantedCoins', (serverRequest, serverResponse) => {
    const { added_coin_id } = serverRequest.query;
    databaseClient.query("SELECT * FROM get_other_user_wanted_coins($1);", [added_coin_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/getCoinsToSwap', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT * FROM get_coincard_coins_to_swap($1);", [access_token], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.post('/sendUserRequest', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];

    let coinToGetId = serverRequest.body.offeredCoinId;

    let coinToGet = serverRequest.body.offeredCoinId;
    coinToGet = getAnArray(coinToGet);

    let coinsToOffer = serverRequest.body.coinsToGet;
    coinsToOffer = getAnArray(coinsToOffer);

    const comment = serverRequest.body.comment;

    databaseClient.query("SELECT insert_coin_request($1, $2, $3, $4, $5);", [access_token, coinToGetId, coinToGet, coinsToOffer, comment], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/getSentSwapRequests', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT * FROM get_sent_swap_requests($1);", [access_token], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/getSwapAddedCoin', (serverRequest, serverResponse) => {
    const { added_coin_id } = serverRequest.query;
    databaseClient.query("SELECT * FROM get_swap_added_coin($1);", [added_coin_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/getReceivedSwapRequests', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];
    databaseClient.query("SELECT * FROM get_received_swap_requests($1);", [access_token], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.post('/sendChangeRequestForm', (serverRequest, serverResponse) => {
    const access_token = serverRequest.cookies['access-token'];

    let coins = serverRequest.body.coinsToSwap;
    coins = getAnArray(coins);
    
    let swapRequestId = serverRequest.body.swapRequestId;

    databaseClient.query("SELECT change_swap_request($1, $2, $3);", [access_token, swapRequestId, coins], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/getSwapRequestChanges', (serverRequest, serverResponse) => {
    const { swap_request_id } = serverRequest.query;
    databaseClient.query("SELECT * FROM get_swap_request_changes($1);", [swap_request_id], (error, databaseResponse) => {
        if (error) {
            console.log(error.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

process.on('exit', function () {
    databaseClient.end();
});
