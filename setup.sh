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
	prefix=
	if [ "$2" != "" ]; then
		prefix=$2
	fi
	case "$tag" in
	upload)
		docker login -u yijun
		for tag in $(services); do
			if [ "$(docker ps -f "name=$tag" --format '{{.Names}}')" == "$tag" ]; then
				docker tag $tag yijun/$tag
				docker push yijun/$tag
		 	fi 
		done
	;;
	xacmllight)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run --name $tag -dit -p 8080:8080 --privileged -it $prefix$tag
	;;
	xacmllight-test)
		if [ $(docker ps -f "name=xacmllight" --format '{{.Names}}') == "xacmllight" ]; then
			docker exec xacmllight apk add --update --no-cache curl
			docker exec xacmllight sed -i -e '/axis2server.sh/d' /xacmllight-2.2/test/send.sh 
			docker exec -it xacmllight sh /xacmllight-2.2/test/send.sh /xacmllight-2.2/test/authz1.xml http://localhost:8080/axis2/services/PdpService getDecision
		fi
	;;
	apache)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run --name $tag -d -p 80:80 --privileged -it $prefix$tag
	;;
	docker-alpine-mysql)
		git clone https://github.com/Leafney/docker-alpine-mysql .
		docker build -t docker-alpine-mysql .
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag -e MYSQL_DATABASE=clouddb -e MYSQL_USER=clouddbuser -e MYSQL_PASSWORD=cloudpassword -e MYSQL_ROOT_PASSWORD=admin -v $(dirname $(pwd))/db:/var/lib/mysql $prefix$tag
	;;
	lamp)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag --link docker-alpine-mysql:server -p 80:80 --privileged -it $prefix$tag
	;;
	lamp-owncloud)
		docker build -t lamp-owncloud .
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag --link docker-alpine-mysql:server -p 80:80 --privileged -it $prefix$tag
	;;
	aware)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag --link docker-alpine-mysql:server --privileged -it $prefix$tag
	;;
	mosquitto)
		docker build -t $tag .
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag -p 8883:8883 --privileged -it $prefix$tag
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
	echo php
	echo xacmllight
	# echo xacmllight-test
	echo docker-alpine-mysql
	# echo apache
	# echo lamp
	echo lamp-owncloud
	echo mosquitto
	#echo aware
}
export -f services
case "$1" in
kill)
	for s in $(services); do
		docker rm -f $s
	done
	;;
run)
	for s in $(services); do
		b $s yijun/
	done
	;;
*)
	for s in $(services); do
		b $s
	done
	# b upload
	;;
esac
