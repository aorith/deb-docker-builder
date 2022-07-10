#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1

Err()   { printf "ERROR: %s\n" "$*" 1>&2; exit 1; }
Usage() {
    [[ -z "$1" ]] || printf "ERROR: %s\n\n" "$1" 1>&2
    cat <<EOF 1>&2
usage: $(basename "$0") [options...]

 Options:
   --src-dir <DIR> Directory containing the required files to build the package.

EOF
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --src-dir)
            shift
            [[ -d "$(realpath "$1")" ]] || Err "Invalid directory: '$1'."
            SRC_DIR=$(realpath "$1")
            shift
            ;;
        *)
            Usage "invalid option '$1'"
            exit 1
            ;;
    esac
done

if [[ -z "$SRC_DIR" ]]; then
    available_builds=()
    while IFS='/' read -r _base _package _debian_tag; do
        available_builds+=( "${_debian_tag}|${_package}" )
    done < <(find "recipes" -maxdepth 2 -mindepth 2 -type d)
    echo "Available packages in 'recipes':"
    {
        for _ab in "${available_builds[@]}"; do
            echo "$_ab"
        done
    } | sort | column -t -s'|' | nl --starting-line-number=1 -w2 -s'.    '
    echo
    read -r -p 'Package # to build: ' ans_n
    [[ "$ans_n" =~ ^[0-9]+$ ]] || Err 'Invalid option (must be numeric).'
    (( ans_n  > 0 )) || Err 'Invalid option.'
    (( ans_n  <= ${#available_builds[@]} )) || Err 'Invalid option.'

    package_to_build=$(awk -F '|' '{print $2}' <<< "${available_builds[$(( ans -1))]}")
    debian_tag=$(awk -F '|' '{print $1}' <<< "${available_builds[$(( ans -1))]}")
    package_path="recipes/${package_to_build}/${debian_tag}"
else 
    debian_tag=$(basename -- "$SRC_DIR")
    package_to_build=$(basename -- "$(dirname -- "$SRC_DIR")" )
    package_path="$SRC_DIR"
fi

# Check if docker is available
docker ps >/dev/null 2>&1 || Err 'Cannot run docker.'

# Build the image
full_image_tag="localhost/deb-docker-builder/debian:${debian_tag}"
dockerfile="Dockerfile"

echo "Running: docker build --tag $full_image_tag --file $dockerfile ."
docker build --build-arg BASE_IMAGE="debian:${debian_tag}" --tag "$full_image_tag" --file "$dockerfile" . \
    || Err "Docker image build failed."
docker image ls "$full_image_tag"

# Docker parameters
docker_args=("-it")

# Comment this out if you want to play with the container
docker_args+=("--rm")

# Avoid writting as root
docker_args+=("-e" "USER=$(id -u)" "-e" "GROUP=$(id -g)")

# Mount required directories
docker_args+=("-v" "$(realpath "$package_path"):/recipe-ro:ro")
docker_args+=("-v" "$(realpath output):/output")

# Run docker
cmd="docker run ${docker_args[*]} $full_image_tag"
echo "Running: $cmd"
echo
exec $cmd
