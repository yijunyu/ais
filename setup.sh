#!/bin/bash
function b() {
	cd $1
	tag=$(basename $(pwd))
	if [ -f Dockerfile ]; then
		docker build -t $tag .
	fi
	case "$tag" in
	upload)
		docker login -u yijun
		docker tag $tag yijun/$tag
		docker push yijun/$tag
	;;
	axis)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run --name $tag -d -p 8080:8080 --privileged -it $tag
	;;
	axis-test)
		docker run --rm --link axis:axis_server --privileged -it $tag
	;;
	apache)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run --name $tag -d -p 81:80 --privileged -it $tag
	;;
	mysql)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag -v $(dirname $(pwd))/db:/data imega/mysql
	;;
	mysql-test)
		docker run --rm --link mysql:server --privileged -it $tag mysql -h server
	;;
	docker-alpine-mysql)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag -e MYSQL_DATABASE=clouddb -e MYSQL_USER=clouddbuser -e MYSQL_PASSWORD=cloudpassword -e MYSQL_ROOT_PASSWORD=admin -v $(dirname $(pwd))/db:/var/lib/mysql $tag
	;;
	owncloud)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag --link docker-alpine-mysql:server -p 80:80 --privileged -it $tag
	;;
	aware)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag --link docker-alpine-mysql:server --privileged -it $tag
	;;
	mosquitto)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag -p 8883:8883 --privileged -it $tag
	;;
	php)
		docker ps -f "name=apache" --format '{{.Names}}'
		if [ $(docker ps -f "name=apache" --format '{{.Names}}') == "apache" ]; then
			 docker exec apache apk add --update --no-cache php5-apache2 openssl\
    php5-json php5-phar php5-openssl php5-mysql php5-curl php5-mcrypt php5-pdo_mysql php5-ctype php5-gd php5-xml php5-dom php5-iconv php5-zip php5-zlib apache2-webdav zlib

		fi
	;;
	esac
	cd -
}
export -f b

function services() {
	b apache
	b php
	b axis
	# b axis-test
	# b mysql
	b docker-alpine-mysql
	b owncloud
	b mosquitto
	b aware
}

services
