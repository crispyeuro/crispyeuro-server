'use strict';

import { readFile } from 'fs/promises';
import pg from 'pg';
import express from 'express';

const app = express();

const client = new pg.Client();


async function test() {
    await client.connect();
    await loadDatabaseCreationCode(client);
    await client.end();
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

app.listen(8080, () => {
    console.log('server is running...');
})
