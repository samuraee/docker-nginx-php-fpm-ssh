# Debian version buster, bullseye
# Use buster for PHP <= 7.3 and bullseye for PHP >= 7.4
ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}-slim

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="Debian Bullseye slim version including apt update"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/debian-slim-apt:${DEBIAN_VERSION}"

ARG NONROOT_USER=scorpion
ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ "Asia/Tehran"

RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime

# Enable Networking
RUN apt update && apt install -y --no-install-recommends \
    curl \
    cron \
    wget \
    gnupg2 \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    autoconf \
    nginx \
    supervisor \
    nodejs \
    zlib1g-dev \
    libmcrypt-dev \
    && apt clean \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# add non-root user
RUN groupadd -g 1000 $NONROOT_USER && \
    useradd -r -u 1000 -g $NONROOT_USER $NONROOT_USER

# give permission to required path to the generated non-root
RUN mkdir -p /var/run/php/ \
    && mkdir -p /var/cache/nginx/ \
    && chown $NONROOT_USER:$NONROOT_USER /run/ -R \
    && chown $NONROOT_USER:$NONROOT_USER /var/ -R \
    && echo '<?php phpinfo(); ?>' > /var/www/index.php

CMD [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]