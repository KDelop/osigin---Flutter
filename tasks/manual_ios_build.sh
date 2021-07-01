#!/bin/bash -e
# Use for manually building on ios

export APP_VERSION="manual"
export APP_API_ENDPOINT="https://example.com"

./tasks/build.sh

flutter build ios