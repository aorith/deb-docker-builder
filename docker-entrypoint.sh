#!/usr/bin/env bash
set -e

echo "=========================================="
echo "        RUNNING /docker-entrypoint.sh"
echo "=========================================="

Err() { printf "ERROR: %s\n" "$*" 1>&2; exit 1; }

# Make the build environment
echo "Creating the build environment..."
mkdir -p /recipe
cp -var /recipe-ro/* /recipe/

# Checks
control_file="/recipe/package/DEBIAN/control"
[[ -f "$control_file" ]] \
    || Err "Debian control file not found on 'package/DEBIAN/control'."
find "/recipe/build/scripts" -mindepth 1 -maxdepth 1 -type f -executable | grep -qz . >/dev/null 2>&1 \
    || Err "No scripts found on 'build/scripts'."

# Run the scripts that actually create the package
echo
echo "Running build scripts..."
find /recipe/build/scripts/ -type f -executable -print0 | while IFS= read -r -d '' script; do
    echo "Running '$script' ..."
    "$script" || Err "Script '$script' failed."
done

# Package name
package_name="$(grep -E '^Package:' < "$control_file" | head -1 | awk '{print $2}')_$(grep -E 'Version:' < "$control_file" | head -1 | awk '{print $2}').deb" 

# Build the package
echo
echo "Building the package..."
cd "/recipe/package"
dpkg-deb --build . "$package_name"

# Run post-scripts
echo "Running post-scripts..."
find /recipe/build/post-scripts/ -type f -executable -print0 | while IFS= read -r -d '' script; do
    echo "Running '$script' ..."
    "$script" || Err "Script '$script' failed."
done

# Move it to the output folder
echo
echo "All done, saving the Debian package outside of the container."
cp -var /recipe/package/*.deb /output/
