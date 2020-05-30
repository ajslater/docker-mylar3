ARG ALPINE_VERSION
FROM python:${ALPINE_VERSION} as builder

# set version label
ARG PKG_VERSION
LABEL version ${ALPINE_VERSION}_mylar-${PKG_VERSION}_builder

RUN \
echo "**** install build system packages ****" && \
 apk add --no-cache \
   git=2.24.3-r0 \
   # unrar-cffi & Pillow build dependencies
   build-base=0.5-r1 \
   # unar-cffi build dependencies
   libffi-dev=3.2.1-r6 \
   # Pillow build dependencies
   zlib-dev=1.2.11-r3 \
   jpeg-dev=8-r6

# For development work I reccomend mounting a full git repo from the
# docker host over /app/mylar.
RUN echo "**** copy shallow app from git ****" && \
 git config --global advice.detachedHead false && \
 git clone https://github.com/mylar3/mylar3.git --depth 1 --branch ${PKG_VERSION} --single-branch /app/mylar

RUN echo "**** install & build python requirements ****" && \
 pip3 install --no-cache-dir -U -r /app/mylar/requirements.txt && \
 rm -rf ~/.cache/pip/*

# Multi stage build

FROM python:${ALPINE_VERSION}
LABEL version ${ALPINE_VERSION}_mylar-${PKG_VERSION}

RUN \
echo "**** install runtime system packages ****" && \
 apk add --no-cache \
 # cfscrape dependecies
 nodejs=12.15.0-r1 \
 # unrar-cffi dependancy
 libffi=3.2.1-r6 \
 # Pillow dependencies
 jpeg=8-r6 \
 zlib=1.2.11-r3

RUN echo "**** copy pre-built python requirements ***"
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages

RUN echo "*** copy app ***"
COPY --from=builder /app/mylar /app/mylar

# ports and volumes
VOLUME /config /comics /downloads
EXPOSE 8090
CMD ["python3", "/app/mylar/Mylar.py", "--nolaunch", "--quiet", "--datadir", "/config/mylar"]
