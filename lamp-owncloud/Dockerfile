FROM yijun/lamp
MAINTAINER Yijun Yu <y.yu@open.ac.uk>
RUN wget http://ftp.icm.edu.pl/packages/owncloud/owncloud-5.0.5.tar.bz2
RUN tar xfj owncloud-5.0.5.tar.bz2 && rm -f owncloud-5.0.5.tar.bz2
RUN mv /owncloud /var/www/localhost/htdocs
RUN mkdir -p /var/www/owncloud/data
RUN mkdir -p /var/www/owncloud/apps
COPY config.php /var/www/localhost/htdocs/owncloud/config/config.php
RUN chown -R apache:apache /var/www/localhost/htdocs/owncloud
RUN chown -R apache:apache /var/www/owncloud
EXPOSE 80
RUN mkdir -p /run/apache
CMD rm -rf /run/apache/* || true && /usr/sbin/httpd -DFOREGROUND
