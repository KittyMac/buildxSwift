docker:
	docker build -t buildxswift .
	docker cp buildxswift:/swift-5.3-amd64-RELEASE-Ubuntu-18.04.tar.gz ./bin/
	docker cp --platform linux/armv7 buildxswift:/swift-5.3-armv7-RELEASE-Ubuntu-18.04.tar.gz ./bin/
	docker cp --platform linux/arm64 buildxswift:/swift-5.3-arm64-RELEASE-Ubuntu-18.04.tar.gz ./bin/
	
docker-buildx:
	-DOCKER_HOST=tcp://192.168.1.209:2376 docker buildx create --name cluster
	-DOCKER_HOST=tcp://192.168.1.170:2376 docker buildx create --name cluster --append
	-DOCKER_HOST=tcp://127.0.0.1:2376 docker buildx create --name cluster --append
	-docker buildx use cluster
	-docker buildx inspect --bootstrap
	docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm64/v8 --push -t kittymac/buildxswift .

docker-shell-386:
	docker run --platform linux/amd64 -it buildxswift sh

docker-shell-armv7:
	docker run --platform linux/arm/v7 -it kittymac/buildxswift:latest sh

docker-shell-arm64:
	docker run --platform linux/arm64/v8 -it kittymac/buildxswift:latest sh
