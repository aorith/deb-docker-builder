ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN find /etc/apt/sources.list* -type f -exec sed -i 'p; s/^deb /deb-src /' '{}' + \
        && find /etc/apt/sources.list* -type f -exec sed -i 's/ main/ main contrib/g' '{}' + # optionally add 'non-free' here

RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bash build-essential cdbs devscripts equivs fakeroot \
        curl gnupg git rsync procps apt-transport-https ca-certificates \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
