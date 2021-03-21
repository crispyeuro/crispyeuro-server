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
    const {year, country, nominal} = serverRequest.query;
    client.query('SELECT * FROM coin WHERE issue_year = $1 AND country = $2 AND denomination = $3', [year, country, nominal], (err, databaseResponse) => {
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

process.on('exit', function() {
    client.end();
});
