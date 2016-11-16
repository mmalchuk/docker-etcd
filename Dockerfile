FROM quay.io/coreos/etcd:latest
MAINTAINER Sergey Vasilenko <stalk@makeworld.ru>

# Set the minimum Docker API version required for libnetwork.
ENV DOCKER_API_VERSION 1.21

# Install runit
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && apk update \
  && apk add runit

# Copy in the filesystem - this contains confd, bird configs
COPY filesystem /

CMD ["start_runit"]
