CREATE TABLE IF NOT EXISTS table_name ();
CREATE TABLE IF NOT EXISTS user_account (
    user_id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(200),
    username VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(200) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    birthday DATE,
    gender VARCHAR(6) CHECK (gender IN ('male', 'female')),
    country VARCHAR(200),
    city VARCHAR(200),
    PRIMARY KEY(user_id)
);
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
/* Insert test data into user_account
 INSERT INTO user_account(
 name,
 username,
 password,
 email,
 birthday,
 gender,
 country,
 city
 )
 VALUES (
 'Mari',
 'mari247',
 'Qw984erty,',
 'mari@mari.ee,',
 '1990-12-23',
 'female',
 'Estonia',
 'Tallinn'
 );
 INSERT INTO user_account(username, password, email, country)
 VALUES (
 'rein589h',
 'Asdfgh1hjk!t5,',
 'rein341@mari.ee,',
 'Estonia'
 );
 */
/*Insert test data into user_status*/
/*INSERT INTO user_status(
        user_id,
        created_on,
        email_verified,
        last_login,
        user_active
    )
VALUES (
        1,
        '2020-03-06 19:20:26-01',
        true,
        '2020-03-06 19:23:38-08',
        true
    );
INSERT INTO user_status(
        user_id, 
        created_on, 
        email_verified, 
        user_active
    )
VALUES (
        2, 
        '2020-03-06 19:31:28-05', 
        false, 
        false
    );
*/
