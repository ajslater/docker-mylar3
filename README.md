# Mylar Docker Image
Mylar is an automated Comic Book manager: https://github.com/mylar3/mylar3
This is a docker image for it.

# Usage
Here are some example snippets to help you get started creating a container from this image.

## docker

```sh
docker create \
  --name=mylar \
  -p 8090:8090 \
  -e PUID=501
  -e PGID=20
  -v <path to data>:/config \
  -v <comics-folder>:/comics \
  -v <downloads-folder>:/downloads \
  --restart unless-stopped \
  ajslater/mylar3
```

## docker-compose.yaml
```yaml
version: "3"
services:
  mylar:
      image: ajslater/mylar3
      container_name: mylar
      restart: on-failure
      env_file: .env
      volumes:
          - <path to data>:/config
          - <path to comics>:/comics
          - <path to downloads>:/downloads
      ports:
          - 8090:8090
```

## Environment Variables

- PUID: Sets the UID for the default user on startup
- PGID: Sets the GID for the default user on startup

Setting TZ and TIMEZONE also helps some programs display correct times.

## Running custom Mylar code

Mylar is run in production the exact same way its run in development. This makes it very easy to run custom branches of Mylar by mounting your own Mylar source code over the docker image's `/app` directory. This technique should work with most other Mylar docker images, not just this one.


### Configure source

#### Clone the Mylar source to your host machine

```sh
$ cd /home/sstrange/code/
$ git clone git@github.com:mylar3/mylar3.git
```

#### Checkout your favorite branch
The current development branch is very popular:

```sh
$ git checkout python3-dev
```

### Configure Docker

#### docker
Like above, but add this `-v` parameter

```sh
   -v /home/sstrange/code/mylar3:/app
```

#### docker-compose.yaml
Like above, but add this line to `volumes`

```yaml
volumes:
  - /home/sstrange/code/mylar3:/app
```

### Running new code

You will have to restart the container to run new code if you checkout a different branch or update the current branch.


## Support Info
- Shell access whilst the container is running:
    - docker exec -it mylar /bin/sh
- To monitor the logs of the container in realtime:
    - docker logs -f mylar
- Container version number
    - docker inspect -f '{{ index .Config.Labels "build_version" }}' mylar
- Image version number
    - docker inspect -f '{{ index .Config.Labels "build_version" }}' ajslater/mylar3

## Docker Image
https://hub.docker.com/r/ajslater/mylar3
