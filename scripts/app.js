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
    if (issue_year === null && country !== null && coin_type !== null) {
        databaseClient.query('SELECT * FROM coin WHERE country = $1 AND coin_type = $2 OR country = $1 AND coin_type = $3 ORDER BY issue_year ASC;', [country, coin_type, coin_type_common], (err, databaseResponse) => {
            if (err) {
                console.log(err.stack);
            } else {
                serverResponse.json(databaseResponse.rows);
            }
        });
    }
    if (country === null && issue_year !== null && coin_type !== null) {
        databaseClient.query('SELECT * FROM coin WHERE issue_year = $1 AND coin_type = $2 OR issue_year = $1 AND coin_type = $3 ORDER BY country ASC;', [issue_year, coin_type, coin_type_common], (err, databaseResponse) => {
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
    databaseClient.query('SELECT coin.*, coin_mintage.coin_mintage_id, coin_mintage.mintage_total, coin_mintage.uncirculated, coin_mintage.brilliant_uncirculated, coin_mintage.proof, coin_mintage.mintmark, coin_mintage.mint, coin_mintage.issue_date, coin_mintage.mintage_description FROM coin LEFT OUTER JOIN coin_mintage ON coin.coin_id = coin_mintage.coin_id WHERE country LIKE $1 ORDER BY coin.issue_year ASC;', [country + '%'], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/denominationRequest', (serverRequest, serverResponse) => {
    const { denomination } = serverRequest.query;
    databaseClient.query('SELECT * FROM coin WHERE denomination = $1 ORDER BY coin.country, coin.issue_year ASC;', [denomination], (err, databaseResponse) => {
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

process.on('exit', function () {
    databaseClient.end();
});
