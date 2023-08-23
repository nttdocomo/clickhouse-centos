FROM centos:7.8.2003

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r -g 11211 memcache && useradd -r -g memcache -u 11211 memcache

ENV CLICKHOUSE_VERSION 20.12.8.5
ARG ARCH=amd64

RUN set -x \
	# install build dependencies for openssl
	&& curl -o clickhouse-common-static.tgz "https://packages.clickhouse.com/repo-archive/tgz/stable/clickhouse-common-static-$CLICKHOUSE_VERSION.tgz" \
	&& mkdir -p /usr/src/clickhouse-common-static \
	&& tar -xzf clickhouse-common-static.tgz -C /usr/src/clickhouse-common-static --strip-components=1 \
	&& /usr/src/clickhouse-common-static/install/doinst.sh

# CMD ["memcached"]