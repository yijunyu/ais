CREATE USER 'clouddbuser'@'server' IDENTIFIED BY 'cloudpassword';
CREATE DATABASE IF NOT EXISTS clouddb;
GRANT ALL PRIVILEGES ON clouddb.* TO 'clouddbuser'@'server' IDENTIFIED BY 'cloudpassword';
update oc_users set password='$2a$08$kZX5a.Z7vhCycapq0FhHOuKBN0p1wwDuCHm36X/6GiPzXme282JDe' where uid='clouddbuser';
