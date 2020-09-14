ARG BASE_VERSION
FROM ajslater/python-alpine:${BASE_VERSION}
ARG PKG_VERSION
LABEL version ${PKG_VERSION}

RUN \
 apk add --no-cache \
 # mylar version detection uses git because it isn't packaged
 git=2.26.2-r0
 
RUN echo "**** copy shallow app from git ****" && \
 git config --global advice.detachedHead false && \
 git clone https://github.com/mylar3/mylar3.git --depth 1 --branch ${PKG_VERSION} --single-branch /app/mylar

RUN \
echo "**** install build system packages ****" && \
 apk add --no-cache \
 # cfscrape dependecies
 nodejs=12.18.3-r0 \
 # unrar-cffi dependancy
 libffi=3.3-r2 \
 # Pillow dependencies
 jpeg=9d-r0 \
 zlib=1.2.11-r3 && \
 apk add --no-cache --virtual=build-dependencies \
   # unrar-cffi & Pillow build dependencies
   build-base=0.5-r2 \
   # unar-cffi build dependencies
   libffi-dev=3.3-r2 \
   # Pillow build dependencies
   jpeg-dev=9d-r0 \
   zlib-dev=1.2.11-r3 && \
 pip3 install --no-cache-dir -U -r /app/mylar/requirements.txt && \
 apk del --purge build-dependencies

COPY cmd.sh .

# ports and volumes
VOLUME /config /comics /downloads /data
EXPOSE 8090
CMD ["./cmd.sh"]
