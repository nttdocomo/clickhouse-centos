FROM centos:7.8.2003

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r -g 11211 memcache && useradd -r -g memcache -u 11211 memcache

ENV CLICKHOUSE_VERSION 20.12.8.5

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ARG ARCH=amd64

RUN set -x \
	# install build dependencies for openssl
	&& curl -o clickhouse-common-static.tgz "https://packages.clickhouse.com/repo-archive/tgz/stable/clickhouse-common-static-$CLICKHOUSE_VERSION.tgz" \
	&& mkdir -p /usr/src/clickhouse-common-static \
	&& tar -xvzf clickhouse-common-static.tgz -C / --strip-components=2 \
	&& curl -o clickhouse-server.tgz "https://packages.clickhouse.com/repo-archive/tgz/stable/clickhouse-server-$CLICKHOUSE_VERSION.tgz" \
	&& mkdir -p /usr/src/clickhouse-server \
	&& tar -xvzf clickhouse-server.tgz -C / --strip-components=2 \
	&& curl -o clickhouse-client.tgz "https://packages.clickhouse.com/repo-archive/tgz/stable/clickhouse-client-$CLICKHOUSE_VERSION.tgz" \
	&& mkdir -p /usr/src/clickhouse-client \
	&& tar -xvzf clickhouse-client.tgz -C / --strip-components=2 \
	&& mkdir -p /var/lib/clickhouse /etc/clickhouse-server/config.d /etc/clickhouse-server/users.d /etc/clickhouse-client /docker-entrypoint-initdb.d \
	&& chown clickhouse:clickhouse /var/lib/clickhouse \
	&& chown root:clickhouse /var/log/clickhouse-server \
	&& chmod ugo+Xrw -R /var/lib/clickhouse /var/log/clickhouse-server /etc/clickhouse-server /etc/clickhouse-client

COPY docker_related_config.xml /etc/clickhouse-server/config.d/
