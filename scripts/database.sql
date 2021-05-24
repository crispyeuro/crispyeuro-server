CREATE EXTENSION IF NOT EXISTS pgcrypto;


/*Logout*/
CREATE OR REPLACE FUNCTION logout(access_token TEXT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM user_session WHERE user_session.access_token = $1;
END;
$$ LANGUAGE plpgsql;


/*Signup*/
CREATE OR REPLACE FUNCTION sign_up(username TEXT, password TEXT, email TEXT)
RETURNS TABLE (access_token TEXT, expiration_date TIMESTAMP) AS $user_session$
DECLARE
    created_user_id INTEGER;
BEGIN
    IF NOT is_username_available($1) THEN
        raise 'Signup error (username is already in use).';
    END IF;
    IF NOT is_username_available($3) THEN
        raise 'Signup error (email is already in use).';
    END IF;
    PERFORM validate_password($2);
    INSERT INTO user_account(username, password, email)
    VALUES ($1, crypt($2, gen_salt('bf')), $3)
    RETURNING user_account.user_id INTO created_user_id;
    RETURN QUERY SELECT * FROM get_user_session(created_user_id);
END;
$user_session$ LANGUAGE plpgsql;


/*Check if username is available*/
CREATE OR REPLACE FUNCTION is_username_available(username TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN NOT EXISTS(SELECT 1 FROM user_account WHERE user_account.username = $1);
END;
$$ LANGUAGE plpgsql;


/*Check if email is available*/
CREATE OR REPLACE FUNCTION is_email_available(email TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN NOT EXISTS(SELECT 1 FROM user_account WHERE user_account.email = $1);
END;
$$ LANGUAGE plpgsql;


/*Validate user account password*/
CREATE OR REPLACE FUNCTION validate_password(password TEXT)
RETURNS VOID AS $$
BEGIN
    IF LENGTH($1) < 6 THEN
        raise 'User password must contain at least six characters.';
    END IF;
    IF LENGTH($1) > 72 THEN
        raise 'User password must contain no more than 72 characters.';
    END IF;
END;
$$ LANGUAGE plpgsql;


/* Returns a session ID if specified user exists and its password is correct */
CREATE OR REPLACE FUNCTION login(username TEXT, password TEXT)
RETURNS TABLE (access_token TEXT, expiration_date TIMESTAMP) AS $user_session$
DECLARE
    selected_user_id INTEGER;
BEGIN
    SELECT user_id 
    FROM user_account
    INTO selected_user_id
    WHERE user_account.username = $1 AND user_account.password = crypt($2, user_account.password);
    IF NOT found THEN
        raise 'Authentication error (invalid username or password)';
    END IF;
    RETURN QUERY SELECT * FROM get_user_session(selected_user_id);
END;
$user_session$ LANGUAGE plpgsql;


/*Get user session if exists. If not, create new user session*/
CREATE OR REPLACE FUNCTION get_user_session(user_id INTEGER)
RETURNS TABLE (access_token TEXT, expiration_date TIMESTAMP) AS $user_session$
DECLARE
    access_token TEXT;
    expiration_date TIMESTAMP;
BEGIN
    SELECT user_session.access_token, user_session.expiration_date
    FROM user_session
    INTO access_token, expiration_date
    WHERE user_session.user_id = $1;
    IF NOT found THEN
        INSERT INTO user_session (user_id) VALUES ($1)
        RETURNING user_session.access_token, user_session.expiration_date INTO access_token, expiration_date;
    END IF;
    IF expiration_date <= now() THEN
        UPDATE user_session
        SET expiration_date = DEFAULT, access_token = DEFAULT
        WHERE user_session.user_id = $1
        RETURNING user_session.access_token, user_session.expiration_date INTO access_token, expiration_date;
    END IF;
    RETURN QUERY VALUES (access_token, expiration_date);
END;
$user_session$ LANGUAGE plpgsql;


/*Insert new coin or update existing coin*/
CREATE OR REPLACE FUNCTION update_coin(access_token TEXT, coin INTEGER, coin_id INTEGER, grade TEXT, coin_value TEXT, amount INTEGER, design TEXT, in_set TEXT, comment TEXT, picturePath TEXT)
RETURNS VOID AS $$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;
    IF $3 = 0 THEN
        INSERT INTO added_coin (coin_id, user_id, grade, coin_value, amount, design, in_set, image_path, comment) 
        VALUES ($2, added_coin_user_id, $4, $5, $6, $7, $8, $10, $9);
    ELSE 
        UPDATE added_coin SET grade = $4, coin_value = $5, amount = $6, design = $7, in_set = $8 , comment = $9, image_path = $10 WHERE added_coin.added_coin_id = $3;
    END IF;
END;
$$ LANGUAGE plpgsql;


/*Delete added coin*/
CREATE OR REPLACE FUNCTION delete_coin(access_token TEXT, coin_id INTEGER)
RETURNS VOID AS $$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;
    DELETE FROM added_coin WHERE added_coin.user_id = added_coin_user_id AND added_coin.added_coin_id = $2;
END;
$$ LANGUAGE plpgsql;


/*Insert true or false into added_coin.awap_availability*/
CREATE OR REPLACE FUNCTION coin_swap_available(access_token TEXT, coin_id INTEGER, swap_checkbox_value TEXT)
RETURNS VOID AS $$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;
    IF $3 = 'addedCoinAvailable' THEN
        UPDATE added_coin SET swap_availability = true WHERE added_coin.user_id = added_coin_user_id AND added_coin.added_coin_id = $2;
    ELSE
        UPDATE added_coin SET swap_availability = false WHERE added_coin.user_id = added_coin_user_id AND added_coin.added_coin_id = $2;
    END IF;
END;
$$ LANGUAGE plpgsql;


/*Get a table for 'Countrycard' according to user access-token*/
CREATE OR REPLACE FUNCTION get_countrycard_table(access_token TEXT, coin_country TEXT)
RETURNS TABLE (coin_id INT, coin_id_added INT, country VARCHAR, issue_year INT, denomination DECIMAL, coin_type VARCHAR, feature VARCHAR, mintage_total INT) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_coin_table AS
    SELECT coin.coin_id, coin.country, coin.issue_year, coin.denomination, coin.coin_type, coin.feature, coin_mintage.mintage_total 
    FROM coin 
    LEFT OUTER JOIN coin_mintage 
    ON coin.coin_id = coin_mintage.coin_id 
    WHERE coin.country 
    LIKE ($2 || '%');

    RETURN QUERY
    SELECT DISTINCT temp_coin_table.coin_id, added_coin.coin_id AS coin_id_added, temp_coin_table.country, temp_coin_table.issue_year, temp_coin_table.denomination, temp_coin_table.coin_type, temp_coin_table.feature, temp_coin_table.mintage_total  
    FROM temp_coin_table 
    LEFT JOIN added_coin 
    ON temp_coin_table.coin_id = added_coin.coin_id 
    AND added_coin.user_id = added_coin_user_id
    ORDER BY temp_coin_table.issue_year ASC;

    DROP TABLE temp_coin_table;
END;
$coins$ LANGUAGE plpgsql;


/*Get a table for 'Denominationcard' according to user access-token*/
CREATE OR REPLACE FUNCTION get_denominationcard_table(access_token TEXT, coin_denomination DECIMAL)
RETURNS TABLE (coin_id INT, coin_id_added INT, country VARCHAR, issue_year INT, denomination DECIMAL, coin_type VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_coin_table AS
    SELECT coin.coin_id, coin.country, coin.issue_year, coin.denomination, coin.coin_type 
    FROM coin 
    WHERE coin.denomination = $2;

    RETURN QUERY
    SELECT DISTINCT temp_coin_table.coin_id, added_coin.coin_id AS coin_id_added, temp_coin_table.country, temp_coin_table.issue_year, temp_coin_table.denomination, temp_coin_table.coin_type  
    FROM temp_coin_table 
    LEFT JOIN added_coin 
    ON temp_coin_table.coin_id = added_coin.coin_id 
    AND added_coin.user_id = added_coin_user_id
    ORDER BY temp_coin_table.country, temp_coin_table.issue_year ASC;

    DROP TABLE temp_coin_table;
END;
$coins$ LANGUAGE plpgsql;


/*Get a table ordered by years for 'Commemorativecard' according to user access-token*/
CREATE OR REPLACE FUNCTION get_commemorative_by_year_table(access_token TEXT, coin_issue_year INTEGER, coin_type_commemorative VARCHAR)
RETURNS TABLE (coin_id INT, coin_id_added INT, country VARCHAR, issue_year INT, coin_type VARCHAR, obverse_image_path VARCHAR, feature VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_coin_table AS
    SELECT coin.coin_id, coin.country, coin.issue_year, coin.coin_type, coin.obverse_image_path, coin.feature  
    FROM coin 
    WHERE coin.issue_year = $2 AND coin.coin_type = $3;

    RETURN QUERY
    SELECT DISTINCT temp_coin_table.coin_id, added_coin.coin_id AS coin_id_added, temp_coin_table.country, temp_coin_table.issue_year, temp_coin_table.coin_type, temp_coin_table.obverse_image_path, temp_coin_table.feature   
    FROM temp_coin_table 
    LEFT JOIN added_coin 
    ON temp_coin_table.coin_id = added_coin.coin_id 
    AND added_coin.user_id = added_coin_user_id
    ORDER BY temp_coin_table.country ASC;

    DROP TABLE temp_coin_table;
END;
$coins$ LANGUAGE plpgsql;


/*Get a table ordered by countries for 'Commemorativecard' according to user access-token*/
CREATE OR REPLACE FUNCTION get_commemorative_by_country_table(access_token TEXT, coin_country VARCHAR, coin_type_commemorative VARCHAR, coin_type_common VARCHAR)
RETURNS TABLE (coin_id INT, coin_id_added INT, country VARCHAR, issue_year INT, coin_type VARCHAR, obverse_image_path VARCHAR, feature VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_coin_table AS
    SELECT coin.coin_id, coin.country, coin.issue_year, coin.coin_type, coin.obverse_image_path, coin.feature 
    FROM coin 
    WHERE coin.country = $2 AND coin.coin_type = $3 
    OR coin.country = $2 AND coin.coin_type = $4;

    RETURN QUERY
    SELECT DISTINCT temp_coin_table.coin_id, added_coin.coin_id AS coin_id_added, temp_coin_table.country, temp_coin_table.issue_year, temp_coin_table.coin_type, temp_coin_table.obverse_image_path, temp_coin_table.feature   
    FROM temp_coin_table 
    LEFT JOIN added_coin 
    ON temp_coin_table.coin_id = added_coin.coin_id 
    AND added_coin.user_id = added_coin_user_id
    ORDER BY temp_coin_table.issue_year ASC;

    DROP TABLE temp_coin_table;
END;
$coins$ LANGUAGE plpgsql;


/*Get a table of added coins to swap for 'Swap' tab according to user access-token*/
CREATE OR REPLACE FUNCTION get_user_added_coins_for_coincard(access_token TEXT, user_coin_id INT)
RETURNS TABLE (country VARCHAR, issue_year INT, denomination DECIMAL, coin_type VARCHAR, coin_id INT, added_coin_id INT, grade VARCHAR, coin_value VARCHAR, amount INT, design VARCHAR, in_set VARCHAR, image_path VARCHAR, comment VARCHAR, swap_availability BOOLEAN) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    RETURN QUERY
    SELECT coin.country, coin.issue_year, coin.denomination, coin.coin_type, added_coin.coin_id, added_coin.added_coin_id, added_coin.grade, added_coin.coin_value, added_coin.amount, added_coin.design, added_coin.in_set, added_coin.image_path, added_coin.comment, added_coin.swap_availability 
    FROM added_coin 
    LEFT JOIN coin
    ON added_coin.coin_id = coin.coin_id 
    WHERE added_coin.user_id = added_coin_user_id 
    AND added_coin.coin_id = $2 
    ORDER BY added_coin.added_coin_id DESC;
END;
$coins$ LANGUAGE plpgsql;


/*Get a table of added coins to swap for 'Swap' tab according to user access-token*/
CREATE OR REPLACE FUNCTION get_user_coins_to_swap(access_token TEXT)
RETURNS TABLE (coin_id INT, coin_id_added INT, coin_type VARCHAR, country VARCHAR, issue_year INT, denomination DECIMAL, swap_availability BOOLEAN) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    RETURN QUERY
    SELECT coin.coin_id, added_coin.added_coin_id AS coin_id_added, coin.coin_type, coin.country, coin.issue_year, coin.denomination, added_coin.swap_availability 
    FROM coin 
    LEFT JOIN added_coin 
    ON coin.coin_id = added_coin.coin_id 
    WHERE added_coin.swap_availability = true
    AND added_coin.user_id = added_coin_user_id;
END;
$coins$ LANGUAGE plpgsql;


/*Change 'swap_availability' value to 'false' in a 'added_coin' table*/
CREATE OR REPLACE FUNCTION change_coin_to_swap_list(access_token TEXT, coin_id INTEGER)
RETURNS VOID AS $$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;
    
    UPDATE added_coin 
    SET swap_availability = false 
    WHERE user_id = added_coin_user_id 
    AND added_coin_id = $2;
END;
$$ LANGUAGE plpgsql;


/*Insert wanted coin into 'wanted_coin' if not found*/
CREATE OR REPLACE FUNCTION add_to_wanted_coin_table(access_token TEXT, coin_id INTEGER)
RETURNS VOID AS $$
DECLARE
    coin_user_id INTEGER;
    wanted_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO coin_user_id WHERE user_session.access_token = $1;
    
    SELECT user_id
    FROM wanted_coin
    INTO wanted_coin_user_id
    WHERE wanted_coin.user_id = coin_user_id
    AND wanted_coin.coin_id = $2;

    IF NOT found THEN
    INSERT INTO wanted_coin (coin_id, user_id) VALUES ($2, coin_user_id);
    END IF;
END;
$$ LANGUAGE plpgsql;


/*Change wanted coin*/
CREATE OR REPLACE FUNCTION change_wanted_coin(access_token TEXT, user_coin_id INTEGER, coin_grade VARCHAR, coin_amount INTEGER, coin_design VARCHAR, coin_inSet VARCHAR, coin_comment VARCHAR)
RETURNS VOID AS $$
DECLARE
    coin_user_id INTEGER;
    wanted_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO coin_user_id WHERE user_session.access_token = $1;
    
    SELECT user_id
    FROM wanted_coin
    INTO wanted_coin_user_id
    WHERE wanted_coin.user_id = coin_user_id;

    IF found THEN
    UPDATE wanted_coin 
    SET grade = $3, amount = $4, design = $5, in_set = $6, comment = $7 
    WHERE wanted_coin.user_id = coin_user_id AND wanted_coin.coin_id = $2;
    END IF;
END;
$$ LANGUAGE plpgsql;


/*Get wanted coin according to user access-token*/
CREATE OR REPLACE FUNCTION get_user_wanted_coin(access_token TEXT, user_coin_id INTEGER)
RETURNS TABLE (coin_id INT, wanted_coin_id INT, grade VARCHAR, amount INT, design VARCHAR, in_set VARCHAR, comment VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    RETURN QUERY 
    SELECT wanted_coin.coin_id, wanted_coin.wanted_coin_id, wanted_coin.grade, wanted_coin.amount, wanted_coin.design, wanted_coin.in_set, wanted_coin.comment 
    FROM wanted_coin
    WHERE wanted_coin.user_id = added_coin_user_id 
    AND wanted_coin.coin_id = $2;
END;
$coins$ LANGUAGE plpgsql;


/*Delete wanted coin*/
CREATE OR REPLACE FUNCTION delete_wanted_coin(access_token TEXT, user_wanted_coin_id INTEGER)
RETURNS VOID AS $$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;
    DELETE FROM wanted_coin WHERE wanted_coin.user_id = added_coin_user_id AND wanted_coin.wanted_coin_id = $2;
END;
$$ LANGUAGE plpgsql;


/*Get wanted coins to swap for a coincard*/
CREATE OR REPLACE FUNCTION get_coincard_swap_wanted_coins(access_token TEXT, user_coin_id INTEGER)
RETURNS TABLE (coin_id INT, wanted_coin_id INT, username VARCHAR, grade VARCHAR, amount INT, design VARCHAR, in_set VARCHAR, comment VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_table AS
    SELECT user_account.user_id, user_account.username 
    FROM user_account;

    RETURN QUERY
    SELECT wanted_coin.coin_id, wanted_coin.wanted_coin_id, temp_table.username, wanted_coin.grade, wanted_coin.amount, wanted_coin.design, wanted_coin.in_set, wanted_coin.comment    
    FROM wanted_coin 
    LEFT JOIN temp_table 
    ON wanted_coin.user_id = temp_table.user_id 
    WHERE wanted_coin.coin_id = $2 
    AND wanted_coin.user_id <> added_coin_user_id;

    DROP TABLE temp_table;
END;
$coins$ LANGUAGE plpgsql;


/*Get other user coins to swap*/
CREATE OR REPLACE FUNCTION getOtherUserCoinsToSwap(user_coin_id INTEGER)
RETURNS TABLE (country VARCHAR, issue_year INT, denomination DECIMAL, coin_type VARCHAR, coin_id INT, added_coin_id INT, grade VARCHAR, amount INT, design VARCHAR, in_set VARCHAR, image_path VARCHAR) AS $coins$ 
DECLARE
    other_user_id INTEGER;
BEGIN
    SELECT wanted_coin.user_id 
    FROM wanted_coin
    INTO other_user_id
    WHERE wanted_coin.wanted_coin_id = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_table AS
    SELECT added_coin.coin_id, added_coin.added_coin_id, added_coin.grade, added_coin.amount, added_coin.design, added_coin.in_set, added_coin.image_path     
    FROM added_coin 
    WHERE added_coin.swap_availability = true
    AND added_coin.user_id = other_user_id;

    RETURN QUERY
    SELECT coin.country, coin.issue_year, coin.denomination, coin.coin_type, temp_table.* 
    FROM temp_table
    LEFT JOIN coin
    ON temp_table.coin_id = coin.coin_id;

    DROP TABLE temp_table;
END;
$coins$ LANGUAGE plpgsql;


/*Send an offer to a user*/
CREATE OR REPLACE FUNCTION insert_coin_offer(access_token TEXT, coinsToOffer INTEGER[], coinsToGet INTEGER[], comment VARCHAR, otherUsername VARCHAR)
RETURNS VOID AS $$
DECLARE
    sender_user_id INTEGER;
    receiver_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO sender_user_id WHERE user_session.access_token = $1;
    SELECT user_account.user_id FROM user_account INTO receiver_user_id WHERE user_account.username = $5;

    INSERT INTO swap_request (sender_id, receiver_id, sender_coins, receiver_coins, comment) VALUES (sender_user_id, receiver_user_id, $2, $3, $4);
END;
$$ LANGUAGE plpgsql;


/*Get offered coins to swap for a coincard*/
CREATE OR REPLACE FUNCTION get_coincard_swap_offered_coins(access_token TEXT, coincard_coin_id INTEGER)
RETURNS TABLE (coin_id INT, added_coin_id INT, username VARCHAR, grade VARCHAR, coin_value VARCHAR, amount INT, design VARCHAR, in_set VARCHAR, image_path VARCHAR, comment VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_table AS
    SELECT user_account.user_id, user_account.username 
    FROM user_account;

    RETURN QUERY
    SELECT added_coin.coin_id, added_coin.added_coin_id, temp_table.username, added_coin.grade, added_coin.coin_value, added_coin.amount, added_coin.design, added_coin.in_set, added_coin.image_path, added_coin.comment    
    FROM added_coin 
    LEFT JOIN temp_table 
    ON added_coin.user_id = temp_table.user_id 
    WHERE added_coin.coin_id = $2 
    AND added_coin.user_id <> added_coin_user_id
    AND added_coin.swap_availability = true;

    DROP TABLE temp_table;
END;
$coins$ LANGUAGE plpgsql;


/*Get other user wanted coins*/
CREATE OR REPLACE FUNCTION get_other_user_wanted_coins(user_coin_id INTEGER)
RETURNS TABLE (country VARCHAR, issue_year INT, denomination DECIMAL, coin_type VARCHAR, coin_id INT, wanted_coin_id INT, grade VARCHAR, amount INT, design VARCHAR, in_set VARCHAR) AS $coins$ 
DECLARE
    other_user_id INTEGER;
BEGIN
    SELECT added_coin.user_id 
    FROM added_coin
    INTO other_user_id
    WHERE added_coin.added_coin_id = $1;

    CREATE TEMP TABLE IF NOT EXISTS temp_table AS
    SELECT wanted_coin.coin_id, wanted_coin.wanted_coin_id, wanted_coin.grade, wanted_coin.amount, wanted_coin.design, wanted_coin.in_set      
    FROM wanted_coin 
    WHERE wanted_coin.user_id = other_user_id;

    RETURN QUERY
    SELECT coin.country, coin.issue_year, coin.denomination, coin.coin_type, temp_table.* 
    FROM temp_table
    LEFT JOIN coin
    ON temp_table.coin_id = coin.coin_id;

    DROP TABLE temp_table;
END;
$coins$ LANGUAGE plpgsql;


/*Get all user coins to swap for a coincard*/
CREATE OR REPLACE FUNCTION get_coincard_coins_to_swap(access_token TEXT)
RETURNS TABLE (country VARCHAR, issue_year INT, coin_type VARCHAR, denomination DECIMAL, coin_id INT, added_coin_id INT, grade VARCHAR, coin_value VARCHAR, amount INT, design VARCHAR, in_set VARCHAR, image_path VARCHAR, comment VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    RETURN QUERY
    SELECT coin.country, coin.issue_year, coin.coin_type, coin.denomination, added_coin.coin_id, added_coin.added_coin_id, added_coin.grade, added_coin.coin_value, added_coin.amount, added_coin.design, added_coin.in_set, added_coin.image_path, added_coin.comment    
    FROM added_coin 
    LEFT JOIN coin
    ON added_coin.coin_id = coin.coin_id
    WHERE added_coin.user_id = added_coin_user_id
    AND added_coin.swap_availability = true;
END;
$coins$ LANGUAGE plpgsql;


/*Send a request to a user*/
CREATE OR REPLACE FUNCTION insert_coin_request(access_token TEXT, coin_to_get_id INT, coin_to_get INTEGER[], coins_to_offer INTEGER[], comment VARCHAR)
RETURNS VOID AS $$
DECLARE
    sender_user_id INTEGER;
    receiver_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO sender_user_id WHERE user_session.access_token = $1;
    SELECT added_coin.user_id FROM added_coin INTO receiver_user_id WHERE added_coin.added_coin_id = $2;

    INSERT INTO swap_request (sender_id, receiver_id, sender_coins, receiver_coins, comment) 
    VALUES (sender_user_id, receiver_user_id, $4, $3, $5);
END;
$$ LANGUAGE plpgsql;


/*Get sent swap requests*/
CREATE OR REPLACE FUNCTION get_sent_swap_requests(access_token TEXT)
RETURNS TABLE (swap_request_id INT, sender_coins INT[], receiver_username VARCHAR, receiver_coins INT[], created_date TIMESTAMP, comment VARCHAR, archived BOOLEAN) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    RETURN QUERY
    SELECT swap_request.swap_request_id, swap_request.sender_coins, user_account.username AS receiver_username, swap_request.receiver_coins, swap_request.created_date, swap_request.comment, swap_request.archived 
    FROM swap_request 
    LEFT JOIN user_account
    ON swap_request.receiver_id = user_account.user_id 
    WHERE swap_request.sender_id = added_coin_user_id 
    ORDER BY swap_request.swap_request_id DESC;
END;
$coins$ LANGUAGE plpgsql;


/*Get added coin for 'Swap' coincard*/
CREATE OR REPLACE FUNCTION get_swap_added_coin(swap_added_coin_id INTEGER)
RETURNS TABLE (country VARCHAR, issue_year INT, denomination DECIMAL, coin_type VARCHAR, obverse_image_path VARCHAR, coin_id INT, added_coin_id INT, grade VARCHAR, coin_value VARCHAR, amount INT, design VARCHAR, in_set VARCHAR, image_path VARCHAR, comment VARCHAR) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    RETURN QUERY
    SELECT coin.country, coin.issue_year, coin.denomination, coin.coin_type, coin.obverse_image_path, added_coin.coin_id, added_coin.added_coin_id, added_coin.grade, added_coin.coin_value, added_coin.amount, added_coin.design, added_coin.in_set, added_coin.image_path, added_coin.comment  
    FROM added_coin 
    LEFT JOIN coin
    ON added_coin.coin_id = coin.coin_id 
    WHERE added_coin.added_coin_id = $1;
END;
$coins$ LANGUAGE plpgsql;


/*Get received swap requests*/
CREATE OR REPLACE FUNCTION get_received_swap_requests(access_token TEXT)
RETURNS TABLE (swap_request_id INT, sender_coins INT[], sender_username VARCHAR, receiver_coins INT[], created_date TIMESTAMP, comment VARCHAR, archived BOOLEAN) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;

    RETURN QUERY
    SELECT swap_request.swap_request_id, swap_request.sender_coins, user_account.username AS sender_username, swap_request.receiver_coins, swap_request.created_date, swap_request.comment, swap_request.archived 
    FROM swap_request 
    LEFT JOIN user_account
    ON swap_request.sender_id = user_account.user_id 
    WHERE swap_request.receiver_id = added_coin_user_id
    ORDER BY swap_request.swap_request_id DESC;
END;
$coins$ LANGUAGE plpgsql;


/*Change offered coins in a swap request*/
CREATE OR REPLACE FUNCTION change_swap_request(access_token TEXT, sender_swap_request INTEGER, coins_to_offer INTEGER[])
RETURNS VOID AS $$
DECLARE
    sender_user_id INTEGER;
    request_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO sender_user_id WHERE user_session.access_token = $1;

    SELECT swap_request.swap_request_id FROM swap_request
    INTO request_id
    WHERE swap_request.swap_request_id = $2
    AND swap_request.sender_id = sender_user_id;

    IF request_id = $2 THEN
    INSERT INTO swap_request_changes (swap_request_id, sender_new_coins) VALUES ($2, $3);
    UPDATE swap_request SET sender_coins = $3 WHERE swap_request_id = $2 AND sender_id = sender_user_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


/*Get swap request changes*/
CREATE OR REPLACE FUNCTION get_swap_request_changes(swap_request_id INTEGER)
RETURNS TABLE (sender_new_coins INT[], changed_date TIMESTAMP) AS $coins$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    RETURN QUERY
    SELECT swap_request_changes.sender_new_coins, swap_request_changes.changed_date 
    FROM swap_request_changes
    WHERE swap_request_changes.swap_request_id = $1 
    ORDER BY swap_request_changes.swap_request_id DESC;
END;
$coins$ LANGUAGE plpgsql;


/*Cancel swap request*/
CREATE OR REPLACE FUNCTION cancel_swap_request(access_token TEXT, cancel_swap_request_id INTEGER)
RETURNS VOID AS $$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;
    DELETE FROM swap_request WHERE swap_request.sender_id = added_coin_user_id AND swap_request.swap_request_id = $2;
END;
$$ LANGUAGE plpgsql;


/*Dismiss swap request*/
CREATE OR REPLACE FUNCTION dismiss_swap_request(access_token TEXT, dismiss_swap_request_id INTEGER)
RETURNS VOID AS $$
DECLARE
    added_coin_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO added_coin_user_id WHERE user_session.access_token = $1;
    DELETE FROM swap_request WHERE swap_request.receiver_id = added_coin_user_id AND swap_request.swap_request_id = $2;
END;
$$ LANGUAGE plpgsql;


/*Send swap request message*/
CREATE OR REPLACE FUNCTION swap_send_message(access_token TEXT, request_id INTEGER, receiver_username VARCHAR, swap_message VARCHAR)
RETURNS VOID AS $$
DECLARE
    sender_user_id INTEGER;
    receiver_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO sender_user_id WHERE user_session.access_token = $1;

    SELECT user_account.user_id 
    FROM user_account 
    INTO receiver_user_id 
    WHERE user_account.username = $3;

    INSERT INTO swap_request_message (swap_request_id, sender_id, receiver_id, message) 
    VALUES ($2, sender_user_id, receiver_user_id, $4);
END;
$$ LANGUAGE plpgsql;


/*Get swap messages*/
CREATE OR REPLACE FUNCTION swap_get_messages(access_token TEXT, swap_id INTEGER)
RETURNS TABLE (message_id INT, sender_username VARCHAR, message VARCHAR, created_date TIMESTAMP) AS $coins$
DECLARE
    request_sender_user_id INTEGER;
    swap_request_user_id_first INTEGER;
    swap_request_user_id_second INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO request_sender_user_id WHERE user_session.access_token = $1;

    SELECT swap_request.sender_id FROM swap_request INTO swap_request_user_id_first WHERE swap_request_id = $2;
    SELECT swap_request.receiver_id FROM swap_request INTO swap_request_user_id_second WHERE swap_request_id = $2;

    IF swap_request_user_id_first = request_sender_user_id OR swap_request_user_id_second = request_sender_user_id THEN 

    RETURN QUERY
    SELECT swap_request_message.swap_request_message_id, user_account.username AS sender_username, 
    swap_request_message.message, swap_request_message.created_date 
    FROM swap_request_message 
    LEFT JOIN user_account 
    ON user_account.user_id = swap_request_message.sender_id 
    WHERE swap_request_message.swap_request_id = $2;
    END IF;
END;
$coins$ LANGUAGE plpgsql;


/*Get user data for 'Settings' tab*/
CREATE OR REPLACE FUNCTION settings_get_user_data(access_token TEXT)
RETURNS TABLE (name VARCHAR, username VARCHAR, email VARCHAR, address VARCHAR) AS $user_data$
DECLARE
    request_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO request_user_id WHERE user_session.access_token = $1;

    RETURN QUERY
    SELECT user_account.name, user_account.username, user_account.email, user_account.address 
    FROM user_account
    WHERE user_account.user_id = request_user_id;
END;
$user_data$ LANGUAGE plpgsql;


/*Change user account data*/
CREATE OR REPLACE FUNCTION change_user_data(access_token TEXT, name TEXT, email TEXT, password TEXT, address TEXT)
RETURNS VOID AS $$
DECLARE
    request_user_id INTEGER;
BEGIN
    SELECT user_session.user_id FROM user_session INTO request_user_id WHERE user_session.access_token = $1;

    PERFORM validate_password($3);
    UPDATE user_account
    SET name = $2, email = $3, password = crypt($4, gen_salt('bf')), address = $5
    WHERE user_id = request_user_id;
END;
$$ LANGUAGE plpgsql;


/*Swap coins*/
CREATE OR REPLACE FUNCTION perform_coins_swap(access_token TEXT, swap_request_id INTEGER)
RETURNS VOID AS $$
DECLARE
    swap_receiver_user_id INTEGER;
    swap_sender_user_id INTEGER;
    swap_sender_coins INTEGER[];
    swap_receiver_coins INTEGER[];
BEGIN
    SELECT user_session.user_id FROM user_session INTO swap_receiver_user_id WHERE user_session.access_token = $1;

    SELECT swap_request.sender_id 
    FROM swap_request 
    INTO swap_sender_user_id 
    WHERE swap_request.swap_request_id = $2 AND swap_request.receiver_id = swap_receiver_user_id;

    SELECT swap_request.sender_coins 
    FROM swap_request 
    INTO swap_sender_coins 
    WHERE swap_request.swap_request_id = $2 AND swap_request.receiver_id = swap_receiver_user_id;

    SELECT swap_request.receiver_coins 
    FROM swap_request 
    INTO swap_receiver_coins 
    WHERE swap_request.swap_request_id = $2 AND swap_request.receiver_id = swap_receiver_user_id;

    EXECUTE swap_change_added_coins_owner(swap_sender_coins, swap_receiver_user_id);
    EXECUTE swap_change_added_coins_owner(swap_receiver_coins, swap_sender_user_id);

    DELETE FROM swap_request WHERE swap_request.swap_request_id = $2;
END;
$$ LANGUAGE plpgsql;


/*Coins swap. Change owner of the added coins*/
CREATE OR REPLACE FUNCTION swap_change_added_coins_owner(coins INTEGER[], coins_receiver_id INTEGER)
RETURNS VOID AS $$
DECLARE
    coins_array_length INT;
    x INT;
BEGIN
    SELECT cardinality($1) INTO coins_array_length;

    IF coins_array_length > 0 THEN
    FOREACH x IN ARRAY $1
    LOOP 
        UPDATE added_coin 
        SET user_id = $2, comment = '', swap_availability = FALSE 
        WHERE added_coin_id = x;
    END LOOP;
    END IF;
END;
$$ LANGUAGE plpgsql;


/*Get added coins for 'Statistics tab'*/
CREATE OR REPLACE FUNCTION statistics_get_added_coins(access_token TEXT)
RETURNS TABLE (coin_id INTEGER, coin_type VARCHAR) AS $statistics_added_coins$
DECLARE
    statistics_user_id INT;
BEGIN
    SELECT user_session.user_id FROM user_session INTO statistics_user_id WHERE user_session.access_token = $1;
    
    RETURN QUERY
    SELECT DISTINCT added_coin.coin_id, coin.coin_type FROM added_coin LEFT JOIN coin ON coin.coin_id = added_coin.coin_id WHERE added_coin.user_id = statistics_user_id;
END;
$statistics_added_coins$ LANGUAGE plpgsql;


/*Get coins for 'Statistics tab'*/
CREATE OR REPLACE FUNCTION statistics_get_coins()
RETURNS TABLE (coin_id INTEGER, coin_type VARCHAR) AS $statistics_added_coins$
BEGIN
    RETURN QUERY
    SELECT coin.coin_id, coin.coin_type FROM coin;
END;
$statistics_added_coins$ LANGUAGE plpgsql;


/*User account*/
CREATE TABLE IF NOT EXISTS user_account (
    user_id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(200),
    username VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(60) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address VARCHAR(200),
    PRIMARY KEY(user_id)
);

/*User session*/
CREATE TABLE IF NOT EXISTS user_session (
    access_token TEXT NOT NULL DEFAULT gen_random_uuid(),
    user_id INT NOT NULL,
    expiration_date TIMESTAMP NOT NULL DEFAULT NOW() + INTERVAL '7 DAY',
    PRIMARY KEY(access_token),
    CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES user_account(user_id)
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
    issue_date VARCHAR(50),
    mintage_description VARCHAR(1000),
    PRIMARY KEY(coin_mintage_id),
    CONSTRAINT fk_coin_id FOREIGN KEY(coin_id) REFERENCES coin(coin_id)
);

/*Added coin*/
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

/*"Swap request" table. sender_coins accepts coins' id from sender "added coins" table*/
/*receiver_coisn accepts user's coins' id from 'added coins'*/
CREATE TABLE IF NOT EXISTS swap_request (
    swap_request_id INT GENERATED ALWAYS AS IDENTITY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    sender_coins INTEGER[],
    receiver_coins INTEGER[],
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    comment VARCHAR(2000),
    archived BOOLEAN,
    PRIMARY KEY(swap_request_id),
    CONSTRAINT fk_sender_id FOREIGN KEY(sender_id) REFERENCES user_account(user_id)
);

/*"Swap request changes" table. "sender_new_coins" accept coins' id from sender's "added coins" table*/
CREATE TABLE IF NOT EXISTS swap_request_changes (
    swap_request_changes_id INT GENERATED ALWAYS AS IDENTITY,
    swap_request_id INT,
    sender_new_coins INTEGER[],
    changed_date TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY(swap_request_changes_id),
    CONSTRAINT fk_swap_request_id FOREIGN KEY(swap_request_id) REFERENCES swap_request(swap_request_id) ON DELETE CASCADE
);

/*Swap request message*/
CREATE TABLE IF NOT EXISTS swap_request_message (
    swap_request_message_id INT GENERATED ALWAYS AS IDENTITY,
    swap_request_id INT,
    sender_id INT,
    receiver_id INT,
    message VARCHAR(2000),
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY(swap_request_message_id),
    CONSTRAINT fk_swap_request_id FOREIGN KEY(swap_request_id) REFERENCES swap_request(swap_request_id) ON DELETE CASCADE,
    CONSTRAINT fk_sender_id FOREIGN KEY(sender_id) REFERENCES user_account(user_id)
);
