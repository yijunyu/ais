## Installation

On a server with docker, you need to run the following command to set up an ownCloud server:
```
./setup.sh
```

Suppose the server has an IP address 40.68.173.115,
after that, you can point your browser to the following URL 
to continue setting up the ownCloud
```
http://40.68.173.115/owncloud/index.php
```


/var/www/localhost/htdocs/owncloud/data


## Troubleshooting
### port number 80
If you see that port 80 has been bound to an earlier docker container, such as in the following message
```
docker: Error response from daemon: driver failed programming external connectivity on endpoint trusting_elion (2ffef4cb76b6de72cb36927ed96d389cd185b5ac874c3a3c2024a154b0851f68): Bind for 0.0.0.0:80 failed: port is already allocated.
```
then you need to run 
```
	docker ps
```
to find out the id of the container, e.g.,
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
5b568bde3201        owncloud            "/bin/sh -c 'rm -r..."   2 minutes ago       Up 2 minutes        0.0.0.0:80->80/tcp       distracted_rosalind
78a603c3cc9c        imega/mysql         "mysqld --skip-gra..."   6 hours ago         Up 6 hours          3306/tcp                 mysql
f42dcfe77b56        axis                "/bin/sh -c /axis2..."   6 hours ago         Up 6 hours          0.0.0.0:8080->8080/tcp   axis
```
and run the following command to kill it before running the setup script again:
```
docker rm -f 5b568bde3201
./setup.sh
```
