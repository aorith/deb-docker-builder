#!/usr/bin/env bash
set -eu -o pipefail

# This scripts runs after the package has been built

# Install and test the package
DEBIAN_FRONTEND=noninteractive apt-get -f install -y /recipe/package/*.deb
/usr/local/bin/hello-world
