FROM centos:7.8.2003

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TZ=UTC \
    CLICKHOUSE_CONFIG=/etc/clickhouse-server/config.xml

# lts / testing / prestable / etc
ARG REPO_CHANNEL="stable"
ARG REPOSITORY="https://packages.clickhouse.com/repo-archive/tgz/${REPO_CHANNEL}"
ARG VERSION="20.12.8.5"
ARG PACKAGES="clickhouse-client clickhouse-server clickhouse-common-static"

RUN set -x \
    && for package in ${PACKAGES}; do \
        { \
            { echo "Get ${REPOSITORY}/${package}-${VERSION}.tgz" \
                && curl -o "/tmp/${package}-${VERSION}.tgz" "${REPOSITORY}/${package}-${VERSION}.tgz" \
                && tar xvzf "/tmp/${package}-${VERSION}.tgz" --strip-components=1 -C / ; \
            } \
        } || exit 1 \
    ; done \
	&& groupadd -r -g 101 clickhouse \
	&& useradd -r -g clickhouse -u 101 clickhouse \
	&& mkdir -p /var/lib/clickhouse /etc/clickhouse-server/config.d /etc/clickhouse-server/users.d /etc/clickhouse-client /docker-entrypoint-initdb.d \
	&& chown clickhouse:clickhouse /var/lib/clickhouse \
	# && chown root:clickhouse /var/log/clickhouse-server \
	&& chmod ugo+Xrw -R /var/lib/clickhouse /etc/clickhouse-server /etc/clickhouse-client

COPY docker_related_config.xml /etc/clickhouse-server/config.d/
