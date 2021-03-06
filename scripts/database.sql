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
    created_on DATE NOT NULL,
    email_verified BOOLEAN,
    last_login DATE,
    user_active BOOLEAN,
    PRIMARY KEY(user_status_id),
    CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES user_account(user_id)
);
