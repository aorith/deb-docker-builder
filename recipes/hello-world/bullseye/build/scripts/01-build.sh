#!/bin/bash
set -e

# Inside of the container you have a full copy of this package in /recipe before
# running the scripts in this directory.
# So if the package is hello-world/bullseye, you would have /recipe/build/... and /recipe/package/...

# Create the directory tree for the resulting debian package
mkdir -p /recipe/package/usr/local/bin
# Build the program
gcc /recipe/build/hello-world.c -o /recipe/package/usr/local/bin/hello-world
# Test the program...
/recipe/package/usr/local/bin/hello-world

# The scripts is this directory execute in order by its name.
# If all the scripts are ran successfully the contents of /recipe/package on the docker
# container will be built as a debian package using 'dpkg-deb'.
