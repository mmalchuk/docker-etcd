#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

function push-to-docker {

    DATE=$(date "+%Y%m%d")
    BDIR=$(pwd)
    WD="$BDIR/tmp-$DATE"
    IMG_ID=$(tail -n 10 $WD/build.log  | grep 'Successfully built' | awk '{print $3}')

    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

    set -o xtrace
    local branch=$TRAVIS_BRANCH
    echo "Using git branch $branch"

    if [ $branch == "master" ]; then
        echo "Pushing with tag - latest"
        docker tag $IMG_ID $DOCKER_REPO:latest && docker push $DOCKER_REPO:latest
    elif [ "${branch:0:8}" == "release-" ]; then
        echo "Pushing from release branch with tag - $branch"
        docker tag $IMG_ID $DOCKER_REPO:$branch && docker push $DOCKER_REPO:$branch
    fi
}

push-to-docker