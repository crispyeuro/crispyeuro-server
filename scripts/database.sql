/*User account*/
CREATE TABLE IF NOT EXISTS user_account (
    user_id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(200),
    username VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(200) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    birthday DATE,
    gender VARCHAR(6) CHECK (gender IN ('male', 'female')),
    country VARCHAR(200),
    address VARCHAR(200),
    PRIMARY KEY(user_id)
);

/*User account status*/
CREATE TABLE IF NOT EXISTS user_status (
    user_status_id INT GENERATED ALWAYS AS IDENTITY,
    user_id INT UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    email_verified BOOLEAN,
    last_login TIMESTAMP,
    user_active BOOLEAN,
    PRIMARY KEY(user_status_id),
    CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES user_account(user_id)
);

/*Coin*/
CREATE TABLE IF NOT EXISTS coin (
    coin_id INT GENERATED ALWAYS AS IDENTITY,
    country VARCHAR(15) NOT NULL,
    issue_year INT NOT NULL,
    denomination DECIMAL NOT NULL,
    coin_type VARCHAR(20),
    obverse_image_path VARCHAR(1000),
    reverse_image_path VARCHAR(1000),
    diameter DECIMAL,
    thickness DECIMAL,
    mass DECIMAL,
    composition VARCHAR(300),
    edge VARCHAR(300),
    feature VARCHAR(300),
    coin_description VARCHAR(1000),
    PRIMARY KEY(coin_id)
);

/*Coin mintage*/
CREATE TABLE IF NOT EXISTS coin_mintage (
    coin_mintage_id INT GENERATED ALWAYS AS IDENTITY,
    coin_id INT NOT NULL,
    mintage_total INT,
    uncirculated INT,
    brilliant_uncirculated INT,
    proof INT,
    mintmark VARCHAR(50),
    mint VARCHAR(300),
    issue_date DATE,
    mintage_description VARCHAR(1000),
    PRIMARY KEY(coin_mintage_id),
    CONSTRAINT fk_coin_id FOREIGN KEY(coin_id) REFERENCES coin(coin_id)
);

/*Added coins*/
CREATE TABLE IF NOT EXISTS added_coin (
    added_coin_id INT GENERATED ALWAYS AS IDENTITY,
    coin_id INT NOT NULL,
    user_id INT NOT NULL,
    grade VARCHAR(20),
    coin_value VARCHAR(20),
    amount INT,
    design VARCHAR(20),
    in_set VARCHAR(20),
    image_path VARCHAR(1000),
    comment VARCHAR(1000),
    swap_availability BOOLEAN,
    PRIMARY KEY(added_coin_id),
    CONSTRAINT fk_coin_id FOREIGN KEY(coin_id) REFERENCES coin(coin_id),
    CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES user_account(user_id)
);

/*Coincard swap settings (enable or disable all coins in the coincard)*/
CREATE TABLE IF NOT EXISTS coincard_swap_settings (
    coincard_swap_settings_id INT GENERATED ALWAYS AS IDENTITY,
    coin_id INT NOT NULL,
    user_id INT NOT NULL,
    swap_enabled BOOLEAN,
    PRIMARY KEY(coincard_swap_settings_id),
    CONSTRAINT fk_coin_id FOREIGN KEY(coin_id) REFERENCES coin(coin_id),
    CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES user_account(user_id)
);

/*Wanted coin*/
CREATE TABLE IF NOT EXISTS wanted_coin (
    wanted_coin_id INT GENERATED ALWAYS AS IDENTITY,
    coin_id INT NOT NULL,
    user_id INT NOT NULL,
    grade VARCHAR(20),
    amount INT,
    design VARCHAR(20),
    in_set VARCHAR(20),
    comment VARCHAR(1000),
    PRIMARY KEY(wanted_coin_id),
    CONSTRAINT fk_coin_id FOREIGN KEY(coin_id) REFERENCES coin(coin_id)
);

/*Contact*/
CREATE TABLE IF NOT EXISTS contact (
    contact_id INT GENERATED ALWAYS AS IDENTITY,
    user_id INT,
    user_contact_id INT UNIQUE,
    PRIMARY KEY(contact_id),
    CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES user_account(user_id)
);

/*Message*/
CREATE TABLE IF NOT EXISTS user_message (
    message_id INT GENERATED ALWAYS AS IDENTITY,
    sender_id INT,
    receiver_id INT,
    message VARCHAR(2000),
    created TIMESTAMP,
    read_receiver BOOLEAN,
    PRIMARY KEY(message_id),
    CONSTRAINT fk_user_id FOREIGN KEY(sender_id) REFERENCES user_account(user_id)
);

/*"Swap request" table. sender_offered_coins accepts coins' id from sender's "added coins" table*/
/*receiver_coin accepts user's coin id from 'added coins'*/
CREATE TABLE IF NOT EXISTS swap_request (
    swap_request_id INT GENERATED ALWAYS AS IDENTITY,
    sender_id INT,
    receiver_id INT,
    sender_offered_coins INTEGER[],
    receiver_coin INT,
    created TIMESTAMP,
    comment VARCHAR(2000),
    archived BOOLEAN,
    PRIMARY KEY(swap_request_id),
    CONSTRAINT fk_sender_id FOREIGN KEY(sender_id) REFERENCES user_account(user_id)
);

/*"Swap request changes" table. offered_coins accept coins' id from sender's "added coins" table*/
CREATE TABLE IF NOT EXISTS swap_request_changes (
    swap_request_changes_id INT GENERATED ALWAYS AS IDENTITY,
    swap_request_id INT,
    offered_coins INTEGER[],
    offer_date_time TIMESTAMP,
    PRIMARY KEY(swap_request_changes_id),
    CONSTRAINT fk_swap_request_id FOREIGN KEY(swap_request_id) REFERENCES swap_request(swap_request_id)
);

/*Swap request message*/
CREATE TABLE IF NOT EXISTS swap_request_message (
    swap_request_message_id INT GENERATED ALWAYS AS IDENTITY,
    swap_request_id INT UNIQUE,
    sender_id INT,
    receiver_id INT,
    message VARCHAR(2000),
    created TIMESTAMP,
    PRIMARY KEY(swap_request_message_id),
    CONSTRAINT fk_swap_request_id FOREIGN KEY(swap_request_id) REFERENCES swap_request(swap_request_id),
    CONSTRAINT fk_sender_id FOREIGN KEY(sender_id) REFERENCES user_account(user_id)
);

/*Insert queries*/
/*Insert test data into 'user_status' table*/
/*INSERT INTO user_status(user_id, created_on, email_verified, last_login, user_active) VALUES (1, '2020-03-06 19:20:26-01', true, '2020-03-06 19:23:38-08', true);
INSERT INTO user_status(user_id, created_on, email_verified, user_active) VALUES (2, '2020-03-06 19:31:28-05', false, false);
*/
/*Insert coins into 'coins' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "EESTI O EESTI 0"');
*/
/*Insert coins' mintages into 'coin_mintage' table*/
/*INSERT INTO coin_mintage (coin_id, mintage_total, uncirculated, brilliant_uncirculated, proof, mint) 
    VALUES (1, 32000000, 50000, 3500, 'Mint of Finland');
INSERT INTO coin_mintage (coin_id, mintage_total, uncirculated, brilliant_uncirculated, proof, mint) 
    VALUES (2, 30000000, 50000, 3500, 'Mint of Finland');
*/
/*Insert added coin into 'added coin'*/
/*INSERT INTO added_coin (coin_id, user_id, grade, coin_value, amount, comment, swap_availability) VALUES (8, 1, 'UNC', '2.5 eur', 1, 'My first coin...', false);
INSERT INTO added_coin (coin_id, user_id, grade, coin_value, amount, comment, swap_availability) VALUES (2, 1, 'UNC', '0.1 cent', 2, 'My second coin...', true);
*/
/*Insert wanted coin into 'wanted_coin'*/
/*INSERT INTO wanted_coin (coin_id, user_id, grade, amount, comment) VALUES (3, 1, 'UNC', 1, 'Want this coin');
*/
/*Insert coincard coin swap settings value*/
/*INSERT INTO coincard_swap_settings (coin_id, user_id, swap_enabled) VALUES (8, 1, false);
*/
