ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN find /etc/apt/sources.list* -type f -exec sed -i 'p; s/^deb /deb-src /' '{}' +

RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bash build-essential cdbs devscripts equivs fakeroot \
        curl gnupg git rsync procps apt-transport-https ca-certificates \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
