# shellcheck disable=SC2148
set -eu

[ -z "$1" ] && echo "Missing 1st parameter. No source image."
[ -z "$2" ] && echo "Missing 2nd parameter. No target image."

SOURCE_IMAGE="$1"
TARGET_IMAGE="$2"

func_travis_ci() {
    docker tag $SOURCE_IMAGE $TARGET_IMAGE
}

func_gitlab_ci() {
    func_travis_ci
}

[ $TRAVIS = "true" ] && func_travis_ci 
[ $GITLAB_CI = "true" ] && func_gitlab_ci