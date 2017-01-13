#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

#set -x

if [ "$TRAVIS_PULL_REQUEST_BRANCH" != "" ]; then
     echo "Test of container skipped for PR. Container will be tested and uploaded after merge."
     exit 0
fi

DATE=$(date "+%Y%m%d")
BDIR=$(pwd)
WD="$BDIR/tmp-$DATE"
IMG_ID=$(tail -n 10 $WD/build.log  | grep 'Successfully built' | awk '{print $3}')

if [ "$IMG_ID" == "" ] ; then
    echo "Container was not successfully built."
    exit 1
fi

echo -n "Check, etcd can start: "
ETCDC=$(docker run -d $IMG_ID)
sleep 2  #  waiting for start etcd
docker exec $ETCDC ps | grep ' etcd ' > /dev/null ; rc=$?
test $rc == 0 && echo 'OK'

echo -n "Check, etcdtool binary exists: "
docker exec $ETCDC etcdtool -v | grep 'etcdtool version ' > /dev/null ; rc=$?
test $rc == 0 && echo 'OK'

echo -n "Check, etcd ready to insert data: "
docker exec $ETCDC etcdctl set test OK ; rc=$?
#test $rc == 0 && echo 'OK'

echo -n "Check, etcdtool can access to etcd: "
docker exec $ETCDC etcdtool export -f yaml / | grep 'test: OK'  > /dev/null ; rc=$?
test $rc == 0 && echo 'OK'

echo 'Etcd instance will be stopped'
docker kill $ETCDC
