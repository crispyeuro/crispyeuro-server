'use strict';

import { readFile } from 'fs/promises';
import pg from 'pg';


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
