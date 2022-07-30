#!/bin/bash
set -eo pipefail

# Inside of the container you have a full copy of this package in /recipe before running the scripts in this directory.
# So if the package is ./recipes/hello-world/bullseye, the folder bullseye is copied over as /recipe in the container

# Create the directory tree for the resulting debian package
mkdir -p /recipe/package/usr/local/bin
# Install dependencies
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y figlet
# Build the program
gcc /recipe/build/hello-world.c -o /recipe/package/usr/local/bin/hello-world
# Test the program...
/recipe/package/usr/local/bin/hello-world

