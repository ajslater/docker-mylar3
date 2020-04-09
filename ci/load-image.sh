#!/bin/bash
set -euo pipefail
source ./env
docker load -i "$1/$IMAGE_ARCHIVE"
