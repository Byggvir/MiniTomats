-- 
-- Setup MySQL / MariaDB MiniTomats database
--
-- You must have permission to create databases on the server
-- run 
--      mysql --user=root --password < setup.sql
--

DROP DATABASE IF EXISTS MiniTomatoes;

CREATE DATABASE IF NOT EXISTS MiniTomatoes;

DROP USER IF EXISTS MiniTomato;
CREATE USER MiniTomato IDENTIFIED BY 'Cherry-Dattel';

GRANT ALL PRIVILEGES ON MiniTomatoes.* TO 'MiniTomato'@'localhost' ;

GRANT FILE ON *.* TO 'MiniTomato'@'localhost';

FLUSH PRIVILEGES;
