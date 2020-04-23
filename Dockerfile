ARG ALPINE_VERSION
FROM python:${ALPINE_VERSION}

# set version label
ARG PKG_VERSION
LABEL version ${ALPINE_VERSION}_${PKG_VERSION}

RUN \
echo "**** install system packages ****" && \
 apk add --no-cache \
 git=2.24.3-r0 \
 # cfscrape dependecies
 nodejs=12.15.0-r1 \
 # unrar-cffi & Pillow dependencies
 build-base=0.5-r1 \
 # unar-cffi dependencies
 libffi-dev=3.2.1-r6 \
 # Pillow dependencies
 zlib-dev=1.2.11-r3 \
 jpeg-dev=8-r6

# It might be better to check out release tags than python3-dev HEAD.
# For development work I reccomend mounting a full git repo from the
# docker host over /app/mylar.
RUN echo "**** install app ****" && \
 git config --global advice.detachedHead false && \
 git clone https://github.com/mylar3/mylar3.git --depth 1 --branch ${PKG_VERSION} --single-branch /app/mylar

RUN echo "**** install requirements ****" && \
 pip3 install --no-cache-dir -U -r /app/mylar/requirements.txt && \
 rm -rf ~/.cache/pip/*

# TODO image could be further slimmed by moving python wheel building into a
# build image and copying the results to the final image.

# ports and volumes
VOLUME /config /comics /downloads
EXPOSE 8090
CMD ["python3", "/app/mylar/Mylar.py", "--nolaunch", "--quiet", "--datadir", "/config/mylar"]
