#!/bin/bash
set -euo pipefail
source .env
docker save -o "$IMAGE_ARCHIVE" "$IMAGE"
