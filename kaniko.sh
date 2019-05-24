# shellcheck disable=SC2148
set -euxv

[ -z "$FOLDER" ] && echo "Variable FOLDER is missing." && exit 1
[ -z "$COMPONENT" ] && echo "Variable COMPONENT is missing." && exit 1
[ -z "$DOCKER_SLUG" ] && echo "Variable DOCKER_SLUG is missing." && exit 1

func_travis_ci() {
    docker run --rm gcr.io/kaniko-project/executor:debug /kaniko/executor 
                        --verbosity info
                        --reproducible
                        --digest-file /dev/termination-log 
                        --context "$TRAVIS_BUILD_DIR/$FOLDER"
                        --dockerfile "$TRAVIS_BUILD_DIR/$FOLDER/Dockerfile"
                        --no-push
                        --build-arg VCS_REF="$TRAVIS_COMMIT" 
                        --build-arg VERSION="$FOLDER" 
                        --build-arg GIT_REPO="https://github.com/$TRAVIS_REPO_SLUG" 
                        --build-arg COMPONENT="$COMPONENT"
                        --build-arg BUILD_DATE="$(date -u +"%Y-%m-%d")"

}

func_gitlab_ci() {
    /kaniko/executor --verbosity info
                      --reproducible
                      --digest-file /dev/termination-log 
                      --context "$CI_PROJECT_DIR/$FOLDER"
                      --dockerfile "$CI_PROJECT_DIR/$FOLDER/Dockerfile"
                      --destination "$CUSTOM_REGISTRY_URL/$CI_PROJECT_NAME:$TAG-dev"
                      --destination "$DOCKER_SLUG/$CI_PROJECT_NAME:$TAG-dev"
                      --cache=true
                      --cache-repo="$CI_REGISTRY_IMAGE/cache"
                      --build-arg VCS_REF="$CI_COMMIT_SHA" 
                      --build-arg VERSION="$FOLDER" 
                      --build-arg GIT_REPO="https://github.com/$DOCKER_SLUG/$CI_PROJECT_NAME" 
                      --build-arg COMPONENT="$COMPONENT" 
                      --build-arg BUILD_DATE="$(date -u +"%Y-%m-%d")"

}

[ $TRAVIS = "true" ] && func_travis_ci 
[ $GITLAB_CI = "true" ] && func_gitlab_ci