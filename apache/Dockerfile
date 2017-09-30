FROM alpine:latest
MAINTAINER Yijun Yu <y.yu@open.ac.uk>
RUN apk add --update --no-cache apache2
EXPOSE 80
RUN mkdir -p /run/apache2
CMD rm -rf /run/apache2/* || true && /usr/sbin/httpd -DFOREGROUND
