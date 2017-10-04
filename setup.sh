#!/bin/bash
function b() {
	if [ -d $1 ]; then
		cd $1
		tag=$(basename $(pwd))
		if [ -f Dockerfile ]; then
			docker build -t $tag .
		fi
	else
		tag=$1
	fi
	case "$tag" in
	upload)
		docker login -u yijun
		docker tag $tag yijun/$tag
		docker push yijun/$tag
	;;
	axis)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run --name $tag -dit -p 8080:8080 --privileged -it $tag
	;;
	axis-test)
		if [ $(docker ps -f "name=axis" --format '{{.Names}}') == "axis" ]; then
			docker exec axis apk add --update --no-cache curl
			docker exec axis sed -i -e '/axis2server.sh/d' /xacmllight-2.2/test/send.sh 
			docker exec -it axis sh /xacmllight-2.2/test/send.sh /xacmllight-2.2/test/authz1.xml http://localhost:8080/axis2/services/PdpService getDecision
		fi
	;;
	apache)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run --name $tag -d -p 81:80 --privileged -it $tag
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
	if [ -d $1 ]; then
		cd -
	fi
}
export -f b

function services() {
	b apache
	b php
	b axis
	# b axis-test
	b docker-alpine-mysql
	b owncloud
	b mosquitto
	#b aware
}

services
