CREATE USER 'clouddbuser'@'server' IDENTIFIED BY 'cloudpassword';
CREATE DATABASE IF NOT EXISTS clouddb;
GRANT ALL PRIVILEGES ON clouddb.* TO 'clouddbuser'@'server' IDENTIFIED BY 'cloudpassword';

