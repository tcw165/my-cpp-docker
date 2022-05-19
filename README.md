# Usage

- Build a docker image.
- Create a container from the image.

Command to build an image from the Dockerfile

```
docker build -t ubuntu:kinetic-cpp my-cpp-docker
```

Command to create a container from the image.

```
docker run -it \
  --name cpp \
  --mount type=volume,source=projects,target=/root/projects \
  --mount type=bind,source=$(pwd)/backup,target=/root/backup \
  ubuntu:kinetic-cpp
  /usr/bin/zsh
```