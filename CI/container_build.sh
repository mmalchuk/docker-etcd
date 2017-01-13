#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [ "$TRAVIS_PULL_REQUEST_BRANCH" != "" ]; then
     echo "Build of container skipped for PR. Container will be builded and uploaded after merge."
     exit 0
fi

DATE=$(date "+%Y%m%d")
BDIR=$(pwd)
WD="$BDIR/tmp-$DATE"
mkdir -p $WD
# cd bird-container
# make build-container

# create build_container
BC_NAME='etcdtool-builder'
docker build -t $BC_NAME -f Dockerfile-builder . && echo "Etcdtool builder container successfully built."

# clone etcdtool repo from github
cd $WD
git clone --branch 3.3.2 https://github.com/mickep76/etcdtool etcdtool
cd etcdtool

docker run -ti --rm -v `pwd`:/go/src/github.com/mickep76/etcdtool $BC_NAME build_etcdtool.sh
if [ -f bin/etcdtool ] ; then
    mkdir -p $BDIR/root/bin
    cp bin/etcdtool $BDIR/root/bin/
    echo "Etcdtool successfully built."
else
    echo "Etcdtool was not successfully built."
    exit 1
fi

# build etcd container
cd $BDIR
docker build -t etcd:latest -f Dockerfile . | tee $WD/build.log

IMG_ID=$(tail -n 10 $WD/build.log  | grep 'Successfully built' | awk '{print $3}')

if [ "$IMG_ID" == "" ] ; then
    echo "Container was not successfully built."
    exit 1
else
    echo "Container successfully built."
fi
