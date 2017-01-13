# docker-etcd [![Build Status](https://travis-ci.org/xenolog/docker-etcd.svg?branch=master)](https://travis-ci.org/xenolog/docker-etcd)
Container with etcd and etcdtool, customizable by ENV  

Variables, allow to customize (and defaults): 

* ETCD_IPV4 (IP address, given from docker)
* ETCD_CLUSTER_NAME (etcd0)
* ETCD_LISTEN_CLIENT_URLS (http://0.0.0.0:2379,http://0.0.0.0:4001)
* ETCD_LISTEN_PEER_URLS (http://0.0.0.0:2380)
* ETCD_ADVERTISE_CLIENT_URLS (http://${ETCD_IPV4}:2379,http://${ETCD_IPV4}:4001)
