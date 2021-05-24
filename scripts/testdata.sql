/*
This file contains test user accounts and added coins.

If the application is to be executed for the first time, 
please uncomment the code below, execute the application, and comment the code below again.
NB! The code below to be executed only once!
*/

SELECT sign_up('testUser', 'testUser123456', 'test@test.com');
SELECT sign_up('testUser2', 'testUser2123456', 'testUser2@test.com');
SELECT sign_up('mari247', 'mari247', 'mari247@test.com');

INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (1, 1, 'BU', 1, false);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 2, 'BU', 2);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (1, 2, 'UNC', 1, true);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 3, 'UNC', 1);
INSERT INTO added_coin(user_id, coin_id, grade, amount, image_path, swap_availability) 
    VALUES (1, 4, 'BU', 1, 'https://www.eestipank.ee/sites/default/files/files/Pangat2hed/kaibemundid/euro/10cent.jpg', false);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 5, 'BU', 1);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 6, 'UNC', 1);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 7, 'Circulation', 1);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (1, 8, 'VF', 1, true);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 355, 'Circulation', 1);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 1600, 'UNC', 5);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 3705, 'UNC', 1);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (1, 3705, 'UNC', 1, true);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (1, 3958, 'Proof', 1);
INSERT INTO added_coin(user_id, coin_id, grade, amount, in_set) VALUES (1, 3709, 'BU', 1, 'coincard');
INSERT INTO added_coin(user_id, coin_id, grade, amount, in_set) VALUES (1, 3904, 'Proof', 1, 'box');

INSERT INTO added_coin(user_id, coin_id, grade, amount, comment) VALUES (2, 34, 'UNC', 1, 'My coin.');
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (2, 630, 'BU', 1, true);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (2, 2877, 'BU', 1, false);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (2, 3618, 'Circulation', 1, false);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (2, 3815, 'Circulation', 1, true);
INSERT INTO added_coin(user_id, coin_id, grade, amount) VALUES (2, 3819, 'UNC', 1);

INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (3, 2, 'UNC', 1, true);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (3, 8, 'UNC', 1, false);
INSERT INTO added_coin(user_id, coin_id, grade, amount, swap_availability) VALUES (3, 8, 'UNC', 1, true);

INSERT INTO wanted_coin(user_id, coin_id, grade, amount, comment) VALUES (1, 3, 'UNC', 1, 'Want this coin');
INSERT INTO wanted_coin(user_id, coin_id, grade, amount, design) VALUES (2, 3, 'Circulation', 1, 'other');
INSERT INTO wanted_coin(user_id, coin_id, amount) VALUES (2, 10, 1);
INSERT INTO wanted_coin(user_id, coin_id, amount) VALUES (2, 24, 1);
INSERT INTO wanted_coin(user_id, coin_id, grade, amount) VALUES (2, 4, 'UNC', 1);
INSERT INTO wanted_coin(user_id, coin_id, grade, amount) VALUES (2, 3705, 'UNC', 1);
INSERT INTO wanted_coin(user_id, coin_id, grade, amount) VALUES (3, 3705, 'UNC', 1);
INSERT INTO wanted_coin(user_id, coin_id, grade, amount) VALUES (3, 3705, 'UNC', 1);
