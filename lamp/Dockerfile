FROM yijun/apache
MAINTAINER Yijun Yu <y.yu@open.ac.uk>
RUN apk add --update --no-cache mysql-client
COPY mysql.ini /etc/php5/conf.d/mysql.ini
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
# Setup apache and php
RUN apk --update --no-cache add php5-apache2 \
    php5-json php5-phar php5-openssl php5-mysql php5-curl php5-mcrypt php5-pdo_mysql php5-ctype php5-gd php5-xml php5-dom php5-iconv php5-zip php5-zlib apache2-webdav zlib\
    && mkdir -p /opt/utils  
EXPOSE 80
RUN mkdir -p /run/apache
CMD rm -rf /run/apache/* || true && /usr/sbin/httpd -DFOREGROUND
