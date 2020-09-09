ARG BASE_VERSION
FROM ajslater/python-alpine:${BASE_VERSION} as builder

RUN \
echo "**** install build system packages ****" && \
 apk add --no-cache \
   git=2.26.2-r0 \
   # unrar-cffi & Pillow build dependencies
   build-base=0.5-r2 \
   # unar-cffi build dependencies
   libffi-dev=3.3-r2 \
   # Pillow build dependencies
   jpeg-dev=9d-r0 \
   zlib-dev=1.2.11-r3

ARG PKG_VERSION
RUN echo "**** copy shallow app from git ****" && \
 git config --global advice.detachedHead false && \
 git clone https://github.com/mylar3/mylar3.git --depth 1 --branch ${PKG_VERSION} --single-branch /app/mylar

RUN echo "**** install & build python requirements ****" && \
 pip3 install --no-cache-dir -U -r /app/mylar/requirements.txt && \
 rm -rf ~/.cache/pip/*

# Multi stage build

FROM ajslater/python-alpine:${BASE_VERSION}
LABEL version mylar-${PKG_VERSION}

RUN \
echo "**** install runtime system packages ****" && \
 apk add --no-cache \
 # mylar version detection uses git because it isn't packaged :o
 git=2.26.2-r0 \
 # cfscrape dependecies
 nodejs=12.18.3-r0 \
 # unrar-cffi dependancy
 libffi=3.3-r2 \
 # Pillow dependencies
 jpeg=9d-r0 \
 zlib=1.2.11-r3

RUN echo "**** copy pre-built python requirements ***"
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages

RUN echo "*** copy app ***"
# For development work I reccomend mounting a full git repo from the
# docker host over /app/mylar.
COPY --from=builder /app/mylar /app/mylar
COPY cmd.sh .

# ports and volumes
VOLUME /config /comics /downloads /data
EXPOSE 8090
CMD ["./cmd.sh"]
