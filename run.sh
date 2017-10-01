#!/bin/bash
function b() {
	tag=$1
	case "$tag" in
	axis)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run --name $tag -d -p 8080:8080 --privileged -it yijun/$tag
	;;
	docker-alpine-mysql)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag -e MYSQL_DATABASE=clouddb -e MYSQL_USER=clouddbuser -e MYSQL_PASSWORD=cloudpassword -e MYSQL_ROOT_PASSWORD=admin -v $(pwd)/db:/var/lib/mysql yijun/$tag
	;;
	owncloud)
		[[ $(docker ps -f "name=$tag" --format '{{.Names}}') == $tag ]] || docker run -d --rm --name $tag --link docker-alpine-mysql:server -p 80:80 --privileged -it yijun/$tag
	;;
	esac
}
export -f b

function services() {
	b axis
	b docker-alpine-mysql
	b owncloud
}

services
