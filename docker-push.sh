# shellcheck disable=SC2148
set -eu

[ -z "$1" ] && echo "Missing 1st parameter. No source image."

SOURCE_IMAGE="$1"

func_travis_ci() {
    docker push $SOURCE_IMAGE
}

func_gitlab_ci() {
    func_travis_ci
}

[ $TRAVIS = "true" ] && func_travis_ci 
[ $GITLAB_CI = "true" ] && func_gitlab_ci