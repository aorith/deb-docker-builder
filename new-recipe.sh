#!/usr/bin/env bash
cd "$(dirname -- "$0")" || exit 1

RECIPES_DIR="./recipes"

read -rp 'Package name: ' pkg_name
[[ -n "$pkg_name" ]] || exit 1
read -rp 'Debian tag (buster, bullseye, ...): ' deb_tag
[[ -n "$deb_tag" ]] || exit 1

if [[ -e "${RECIPES_DIR}/${pkg_name}" ]]; then
    echo "A package with that name already exists."
    exit 1
fi

recipe_dir="${RECIPES_DIR}/${pkg_name}/${deb_tag}"
mkdir -p "${recipe_dir}/"{package/DEBIAN,build/scripts,build/post-scripts}

cat <<EOF > "${recipe_dir}/package/DEBIAN/control"
Package: ${pkg_name}
Version: 0.1~${deb_tag}
Architecture: amd64
Maintainer: Manuel Sanchez <aomanu@gmail.com>
Depends: curl, wget
Section: custom
Priority: optional
Homepage:
Description: Example
EOF

printf '\nThe skeleton for the package "%s" for "%s" has been generated.\n\n' "$pkg_name" "$deb_tag"
printf 'Go ahead and modify as required the control file located at "%s"\nThen, create the required scripts and files to build the package under "%s"\n' \
    "${recipe_dir}/package/DEBIAN/control" "${recipe_dir}/build"
printf 'When everything is set-up, run ./build.sh\n'
