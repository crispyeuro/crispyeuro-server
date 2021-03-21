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

/*User collection settings*/
CREATE TABLE IF NOT EXISTS collection_settings (
    collection_settings_id INT GENERATED ALWAYS AS IDENTITY,
    user_id INT,
    basic_level BOOLEAN,
    advanced_level BOOLEAN,
    very_advanced_level BOOLEAN,
    missing_coins BOOLEAN,
    german_mints BOOLEAN,
    PRIMARY KEY(collection_settings_id),
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
/*Insert ESTONIA coins into 'coin' table
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "EESTI O EESTI 0"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "EESTI O EESTI 0"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Estonia', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
*/
/*Insert LATVIA coins into 'coin' table
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "DIEVS * SVĒTĪ * LATVIJU"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "DIEVS * SVĒTĪ * LATVIJU"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "DIEVS * SVĒTĪ * LATVIJU"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "DIEVS * SVĒTĪ * LATVIJU"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "DIEVS * SVĒTĪ * LATVIJU"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "DIEVS * SVĒTĪ * LATVIJU"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Latvia', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "DIEVS * SVĒTĪ * LATVIJU"');
*/

/*Set client encoding to 'UTF8'*/
/*SET client_encoding TO 'UTF8';
*/

/*Insert LITHUANIA coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "LAISVĖ * VIENYBĖ * GEROVĖ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "LAISVĖ * VIENYBĖ * GEROVĖ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "LAISVĖ * VIENYBĖ * GEROVĖ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "LAISVĖ * VIENYBĖ * GEROVĖ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "LAISVĖ * VIENYBĖ * GEROVĖ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Lithuania', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "LAISVĖ * VIENYBĖ * GEROVĖ"');
*/

/*Insert ANDORRA coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Andorra', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');
*/

/*Insert AUSTRIA coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Austria', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 EURO *** 2 EURO *** 2 EURO *** 2 EURO ***"');
*/

/*Insert BELGIUM coin into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 1999, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2000, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2001, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Belgium', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **"');
*/

/*Insert CYPRUS coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Cyprus', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ΕΥΡΩ 2 EURO 2 ΕΥΡΩ 2 EURO"');
*/

/*Insert FINLAND coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 1999, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2000, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2001, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Finland', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "SUOMI FINLAND", 3 lion heads');
*/

/*Insert FRANCE coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 1999, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2000, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2001, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('France', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', 'Reeded with inscription: "2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');
*/

/*Insert GREECE coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Greece', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"ΕΛΛΗΝΙΚΗ ΔΗΜΟΚΡΑΤΙΑ"');
*/

/*Insert IRELAND coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Ireland', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');
*/

/*Insert ITALY coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Italy', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');
*/

/*Insert LUXEMBOURG coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Luxembourg', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 ** 2 ** 2 ** 2 ** 2 ** 2 **" upright and inverted');
*/

/*Insert PORTUGAL coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Portugal', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '7 castles and 5 coats of arms');
*/

/*Insert VATICAN coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Vatican', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');
*/

/*Insert SPAIN coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 1999, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2000, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2001, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Spain', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 * " upright and inverted');
*/

/*Insert NETHERLANDS coins into 'coins' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 1999, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2000, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2001, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Netherlands', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"GOD * ZIJ * MET * ONS *"');
*/

/*Insert SAN MARINO coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('San-Marino', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * 2 * 2 * 2 * 2 * 2 *" upright and inverted');
*/

/*Insert SLOVENIA coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovenia', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENIJA"');
*/

/*Insert SLOVAKIA coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Slovakia', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"SLOVENSKÁ REPUBLIKA", star on both sides of lettering');
*/

/*Insert MALTA coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Malta', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '6 times "2", 2 Maltese crosses, upright and inverted');
*/

/*Insert MONACO coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2001, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Monaco', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"2 * * 2 * * 2 * * 2 * * 2 * * 2 * *", upright and inverted');
*/

/*Insert GERMANY "A" coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"A"', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');
*/

/*Insert GERMANY "D" coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"D"', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');
*/

/*Insert GERMANY "F" coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"F"', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');
*/

/*Insert GERMANY "G" coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"G"', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');
*/

/*Insert GERMANY "J" coins into 'coin' table*/
/*INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2002, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2003, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2004, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2005, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2006, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2007, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2008, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2009, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2010, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2011, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2012, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2013, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2014, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2015, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2016, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2017, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2018, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2019, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2020, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');

INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '0.01', 'ordinary', 16.25, 1.67, 2.3, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '0.02', 'ordinary', 18.75, 1.67, 3.06, 'Copper-covered steel', 'Smooth with a groove');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '0.05', 'ordinary', 21.25, 1.67, 3.92, 'Copper-covered steel', 'Smooth');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '0.1', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Shaped edge with file scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '0.2', 'ordinary', 22.25, 2.14, 5.74, 'Nordic gold', 'Plain with seven indents (Spanish flower)');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '0.5', 'ordinary', 24.25, 2.38, 7.8, 'Nordic gold', 'Shaped edge with fine scallops');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '1', 'ordinary', 23.25, 2.33, 7.5, 'Outer part: nickel brass, Inner part: Layers of copper-nickel, nickel, copper-nickel', 'Interrupted milled');
INSERT INTO coin(country, issue_year, denomination, coin_type, diameter, thickness, mass, composition, edge) 
    VALUES ('Germany-"J"', 2021, '2', 'ordinary', 25.75, 2.2, 8.5, 'Inner part: copper-nickel, Inner part: Layers of nickel brass, nickel, nickel brass', '"EINIGKEIT UND RECHT UND FREIHEIT"');
*/
