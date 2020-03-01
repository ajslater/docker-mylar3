# Mylar Docker Image
Mylar is an automated Comic Book downloader and organizer (cbr/cbz) for use with SABnzbd, NZBGet and torrents.

# Usage
Here are some example snippets to help you get started creating a container from this image.

## docker

```sh
docker create \
  --name=mylar \
  -p 8090:8090 \
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

## Support Info
- Shell access whilst the container is running:
    - docker exec -it mylar /bin/bash
- To monitor the logs of the container in realtime:
    - docker logs -f mylar
- Container version number
    - docker inspect -f '{{ index .Config.Labels "build_version" }}' mylar
- Image version number
    - docker inspect -f '{{ index .Config.Labels "build_version" }}' ajslater/mylar3

## Docker Image
https://hub.docker.com/r/ajslater/mylar3
