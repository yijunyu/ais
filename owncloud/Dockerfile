FROM yijun/apache-alpine
MAINTAINER Yijun Yu <y.yu@open.ac.uk>
RUN apk add --update --no-cache mysql-client
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
# Setup apache and php
RUN apk --update --no-cache add php5-apache2 \
    php5-json php5-phar php5-openssl php5-mysql php5-curl php5-mcrypt php5-pdo_mysql php5-ctype php5-gd php5-xml php5-dom php5-iconv php5-zip php5-zlib apache2-webdav zlib\
    && mkdir -p /opt/utils  
RUN wget http://ftp.icm.edu.pl/packages/owncloud/owncloud-5.0.5.tar.bz2
RUN tar xfj owncloud-5.0.5.tar.bz2 && rm -f owncloud-5.0.5.tar.bz2
RUN mv /owncloud /var/www/localhost/htdocs
RUN mkdir -p /var/www/owncloud/data
RUN mkdir -p /var/www/owncloud/apps
COPY mysql.ini /etc/php5/conf.d/mysql.ini
COPY config.php /var/www/localhost/htdocs/owncloud/config/config.php
RUN chown -R apache:apache /var/www/localhost/htdocs/owncloud
RUN chown -R apache:apache /var/www/owncloud
EXPOSE 80
