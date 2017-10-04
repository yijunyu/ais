FROM yijun/apache-alpine
MAINTAINER Yijun Yu <y.yu@open.ac.uk>
RUN apk add --update --no-cache mosquitto mosquitto-clients
RUN apk add --update --no-cache git
RUN cd ~ && git clone https://github.com/jpmens/mosquitto-auth-plug 
RUN cd ~/mosquitto-auth-plug && cp config.mk.in config.mk && \
    sed -i -e "s/BACKEND_MYSQL ?= no/BACKEND_MYSQL ?= yes/" -e "s/MOSQUITTO_SRC = /MOSQUITTO_SRC = ..\/mosquitto-1.4.10/" config.mk
RUN mkdir ~/mosquitto_driver
COPY mosquitto-1.4.10.tar.gz /mosquitto-1.4.10.tar.gz 
RUN cd ~/mosquitto_driver && tar xzf /mosquitto-1.4.10.tar.gz 
RUN apk add --update --no-cache alpine-sdk
RUN apk add --update --no-cache openssl-dev
RUN apk add --update --no-cache libwebsockets-dev
RUN apk add --update --no-cache util-linux-dev
RUN cd ~/mosquitto_driver/mosquitto-1.4.10 && \
    sed -i -e "s/WITH_SRV:=yes/WITH_SRV:=no/" -e "s/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/" config.mk && \
    find . -name "Makefile" | xargs sed -i -e "s/--strip-program=.*STRIP. //" && \
    make clean && make && make install
RUN apk del openssl-dev
RUN apk add --update --no-cache mysql-dev
RUN cd ~/mosquitto-auth-plug && make clean && make && chmod 777 auth-plug.so
#RUN chmod -R 777 /var/log/mosquitto
EXPOSE 8883
