
CONTAINER_NAME=erlang-build-box

docker.build:
	docker build --rm -t ${CONTAINER_NAME} .

docker.shell:
	sudo docker run --rm -ti -v ../:~/src --name ${CONTAINER_NAME} ${CONTAINER_NAME} /sbin/my_init -- bash -l



docker.clean: docker.clean.containers docker.clean.none-images
	@echo "Clean all"
	docker rmi ${CONTAINER_NAME}:latest

docker.clean.containers:
	@echo "Clean stopped containers"
	docker rm `docker ps --no-trunc -a -q`

docker.clean.none-images:
	@echo "Clean <none> images"
	docker rmi `docker images | grep "^<none>" | awk "{print $3}"`
