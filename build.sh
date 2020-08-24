#!/bin/bash
set -euo pipefail
source ./env
docker build -t $IMAGE --build-arg BASE_VERSION=$BASE_VERSION --build-arg PKG_VERSION=$PKG_VERSION .
