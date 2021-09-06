# Debian version buster, bullseye
# Use buster for PHP <= 7.3 and bullseye for PHP >= 7.4
ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}-slim

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="Debian Bullseye slim version including apt update"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/debian-slim-apt:${DEBIAN_VERSION}"

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ "Asia/Tehran"
ENV SSH_AUTHORIZED_KEYS ""

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
    openssh-server \
    && apt clean \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# add non-root user
RUN groupadd -g 1000 nazgul && \
    useradd -r -u 1000 -g nazgul nazgul

# give permission to required path to the generated non-root
RUN mkdir -p /var/run/php/ \
    && mkdir -p /var/cache/nginx/ \
    && mkdir /run/sshd/ \
    && chown nazgul:nazgul /run/ -R \
    && chown nazgul:nazgul /var/ -R \
    && chown nazgul /etc/ssh/ -R \
    && echo '<?php phpinfo(); ?>' > /var/www/index.php

# add ssh keys
RUN mkdir -p ~/.ssh \
    && touch ~/.ssh/authorized_keys \
    && echo "${SSH_AUTHORIZED_KEYS}" > ~/.ssh/authorized_keys \
    && chown 600 ~/.ssh/authorized_keys

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]