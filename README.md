## Installation
On a server with docker, you need to run the following command to set up an ownCloud server:
```
./setup.sh
```

## Setup Owncloud database

The set up the database for ownCloud, you need to create them if it has not existed:
```
docker run --rm --link docker-alpine-mysql:server --privileged -it mysql-test mysqladmin -h server -u root --password=mysql < init.sql
```

The content of `init.sql` is listed here for information:
```
CREATE USER 'clouddbuser'@'server' IDENTIFIED BY 'cloudpassword';
CREATE DATABASE IF NOT EXISTS clouddb;
GRANT ALL PRIVILEGES ON clouddb.* TO 'clouddbuser'@'server' IDENTIFIED BY 'cloudpassword';
```

Then restart the set up process:
```
./setup.sh
```

Suppose the server has an IP address 40.68.173.115,
after that, you can point your browser to the following URL 
to continue setting up the ownCloud
```
http://40.68.173.115/owncloud/index.php
```
