'use strict';

import { readFile } from 'fs/promises';
import pg from 'pg';
import express from 'express';

const app = express();

const client = new pg.Client();

async function test() {
    await client.connect();
    await loadDatabaseCreationCode(client);
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

app.use('/scripts', express.static('../crispyeuro-client/scripts'));
app.use('/static', express.static('../crispyeuro-client/static'));
app.use('/styles', express.static('../crispyeuro-client/styles'));

app.get('/', (req, res) => {
    res.redirect('/static');
})

app.get('/api/first-row', (serverRequest, serverResponse) => {
    client.query('SELECT * FROM coin WHERE coin_id = $1', [1], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    })
});

app.get('/api/lala', (serverRequest, serverResponse) => {
    const { coin_id } = serverRequest.query;
    client.query('SELECT coin.*, coin_mintage.coin_mintage_id, coin_mintage.mintage_total, coin_mintage.uncirculated, coin_mintage.brilliant_uncirculated, coin_mintage.proof, coin_mintage.mintmark, coin_mintage.mint, coin_mintage.issue_date, coin_mintage.mintage_description FROM coin LEFT OUTER JOIN coin_mintage ON coin.coin_id = coin_mintage.coin_id WHERE coin.coin_id = $1;', [coin_id], (err, databaseResponse) => {
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
        client.query('SELECT * FROM coin WHERE country = $1 AND coin_type = $2 OR country = $1 AND coin_type = $3 ORDER BY issue_year ASC;', [country, coin_type, coin_type_common], (err, databaseResponse) => {
            if (err) {
                console.log(err.stack);
            } else {
                serverResponse.json(databaseResponse.rows);
            }
        });
    }
    if (country === null && issue_year !== null && coin_type !== null) {
        client.query('SELECT * FROM coin WHERE issue_year = $1 AND coin_type = $2 OR issue_year = $1 AND coin_type = $3 ORDER BY country ASC;', [issue_year, coin_type, coin_type_common], (err, databaseResponse) => {
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
    client.query('SELECT coin.*, coin_mintage.coin_mintage_id, coin_mintage.mintage_total, coin_mintage.uncirculated, coin_mintage.brilliant_uncirculated, coin_mintage.proof, coin_mintage.mintmark, coin_mintage.mint, coin_mintage.issue_date, coin_mintage.mintage_description FROM coin LEFT OUTER JOIN coin_mintage ON coin.coin_id = coin_mintage.coin_id WHERE country LIKE $1 ORDER BY coin.issue_year ASC;', [country+'%'], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/denominationRequest', (serverRequest, serverResponse) => {
    const { denomination } = serverRequest.query;
    client.query('SELECT * FROM coin WHERE denomination = $1 ORDER BY coin.country, coin.issue_year ASC;', [denomination], (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.get('/api/indexCoinsRequest', (serverRequest, serverResponse) => {
    client.query("SELECT * FROM coin ORDER BY coin.country, coin.issue_year ASC;", (err, databaseResponse) => {
        if (err) {
            console.log(err.stack);
        } else {
            serverResponse.json(databaseResponse.rows);
        }
    });
});

app.listen(8080, () => {
    console.log('server is running...');
})

process.on('exit', function () {
    client.end();
});
