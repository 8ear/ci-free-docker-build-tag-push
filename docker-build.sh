# shellcheck disable=SC2148
set -eu

[ -z "$FOLDER" ] && echo "Variable FOLDER is missing." && exit 1
[ -z "$COMPONENT" ] && echo "Variable COMPONENT is missing." && exit 1
[ -z "$DOCKER_SLUG" ] && echo "Variable DOCKER_SLUG is missing." && exit 1

func_travis_ci() {
docker build \
    --build-arg VCS_REF="$TRAVIS_COMMIT" \
    --build-arg VERSION="$FOLDER" \
    --build-arg GIT_REPO="https://github.com/$TRAVIS_REPO_SLUG" 
    --build-arg COMPONENT="$COMPONENT" \
    --build-arg BUILD_DATE="$(date -u +"%Y-%m-%d")" \
    -t "$TRAVIS_REPO_SLUG-dev" \
    -f "$TRAVIS_BUILD_DIR/$FOLDER/Dockerfile"
    "$TRAVIS_BUILD_DIR/$FOLDER"

}

func_gitlab_ci() {
docker build \
    --build-arg VCS_REF="$CI_COMMIT_SHA" \
    --build-arg VERSION="$FOLDER" \
    --build-arg GIT_REPO="https://github.com/$DOCKER_SLUG/$CI_PROJECT_NAME" \
    --build-arg COMPONENT="$COMPONENT" \
    --build-arg BUILD_DATE="$(date -u +"%Y-%m-%d")" \
    -t "$CUSTOM_REGISTRY_URL/$CI_PROJECT_NAME:$TAG-dev" \
    -t "$DOCKER_SLUG/$CI_PROJECT_NAME:$TAG-dev" \
    -f "$CI_PROJECT_DIR/$FOLDER/Dockerfile" \
    "$CI_PROJECT_DIR/$FOLDER"

}


[ $TRAVIS = "true" ] && func_travis_ci 
[ $GITLAB_CI = "true" ] && func_gitlab_ci