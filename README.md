# Usage

- Build a docker image.
- Create a container from the image.

Command to build an image from the Dockerfile

```
docker build -t ubuntu:cpp my-cpp-docker
```

Command to create a container from the image.

```
docker run -it \
  --name cpp \
  --mount type=bind,source=$(echo $HOME)/projects,target=/projects \
  ubuntu:cpp \
  /usr/bin/zsh
```

# Enable ssh root@localhost

Find `PermitRootLogin` and change it to `PermitRootLogin yes` in `/etc/ssh/sshd_config`.

Then run `service ssh start`.

You could use `service --status-all` to check if ssh server is running.