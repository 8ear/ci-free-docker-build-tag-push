CI Independent Docker commands to Build Docker Container
===
This repository contains CI independent shellscripts to build Docker container.

# About
Since 2018 I build docker containers, most of them are opensource. 
As code utility for any opensource projects we use github.com. Internally we use a Gitlab CI to build the images and upload them to the Docker registries. This build logs can't be seen by the opensource community, so we use Travis CI to build the images again. Both the Gitlab CI and the Travis CI have different variable names and techniques for building docker containers.
So I decided to build CI independent shellscripts so you don't have to worry about which CI has which variable every time.

## Examples of CI differences

|                                           | Gitlab CI Var Name | Travis CI Var Name |
| ----------------------------------------- | ------------------ | ------------------ |
| Git Commit Hash:                          | CI_COMMIT_SHA      | TRAVIS_COMMIT      |
| Directory where the build files are:      | CI_PROJECT_DIR     | TRAVIS_BUILD_DIR   |
| Not complete comparable but very similar: | CI_PROJECT_NAME    | TRAVIS_REPO_SLUG   |

### Additional Examples
Gitlab CI Example:

```yml
.build:
  stage: build
  only:
  - master
  - schedules
  - feat/MDD-169
  image:
    # :debug for gitlab-ci sh in image
    name: gitlab.dcso.lolcat:4567/misp/helper-containers:kaniko
  script:
    - /kaniko/executor --verbosity info
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
                      --build-arg GIT_REPO="https://github.com/DCSO/$CI_PROJECT_NAME" 
                      --build-arg COMPONENT="db" 
                      --build-arg BUILD_DATE="$(date -u +"%Y-%m-%d")"
```

Travis CI Example:
```yml
script:
- docker run --rm gcr.io/kaniko-project/executor:debug /kaniko/executor 
                      --verbosity info
                      --reproducible
                      --digest-file /dev/termination-log 
                      --context "$TRAVIS_BUILD_DIR/$FOLDER"
                      --dockerfile "$TRAVIS_BUILD_DIR/$FOLDER/Dockerfile"
                      --no-push
                      --build-arg VCS_REF="$TRAVIS_COMMIT" 
                      --build-arg VERSION="$FOLDER" 
                      --build-arg GIT_REPO="https://github.com/$TRAVIS_REPO_SLUG" 
                      --build-arg COMPONENT="db"
                      --build-arg BUILD_DATE="$(date -u +"%Y-%m-%d")"
```

You can see, at Gitlab CI start the script commands directly in an customized docker image. Travis CI has no option for this current. You can use Travis CI with docker yes, but in an other way.

To prevent this and make it easy as possible for me and all other I write here shellscripts to which can be executed in both CIs.

# Todos:
- [ ] Create Docker build shellscript
- [ ] Create Docker tag shellscript
- [ ] Create Docker push shellscript
- [ ] Create Docker kaniko shellscript

# Not supported
- Circle CI

# License
Please look at License file.