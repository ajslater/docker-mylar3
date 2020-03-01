#!/bin/bash
set -euo pipefail
./build.sh
docker-compose up
