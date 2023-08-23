FROM centos:7.8.2003

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r -g 11211 memcache && useradd -r -g memcache -u 11211 memcache

ENV CLICKHOUSE_VERSION 20.12.8.5
ARG ARCH=amd64

RUN set -x \
	# install build dependencies for openssl
	&& curl -o clickhouse-common-static.tar.gz "https://packages.clickhouse.com/tgz/stable/clickhouse-common-static-$CLICKHOUSE_VERSION-$ARCH.tgz"

# CMD ["memcached"]