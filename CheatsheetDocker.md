## Docker cmd Cheatsheet
```
  $ docker images
  $ docker ps [-a for all]
  $ docker pull <image>:[opt_ver]
  $ docker run <image>
	--name <name>
	-d (run in background)
	-it (run with interactive shell)
	-e [key1=value1] -e [key2=value2]
  $ docker exec -it <container_name> bash
  $ docker inspect <name>
  $ docker restart <container_name>
  $ docker stop $(docker ps -q) [=stop all containers]
  $ docker rm $(docker ps -aq) [=delete all containers]
  $ docker logs <container_name>
  $ docker rmi <image_name>
  $ docker save [-o FILE_NAME] IMAGE_NAME[:TAG]
  $ docker load [-i FILE_NAME]
  $ docker tag IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]
  $ docker push <image_name>
  $ docker rmi $(docker images -q) [=delete all images]
  $ docker diff <image_name>
```
[Docker cmdline reference](https://docs.docker.com/engine/reference/commandline/docker/)
