# Debian version buster, bullseye
ARG DEBIAN_VERSION
# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION=7.1

FROM aboozar/nginx-php-base:$PHP_VERSION

ARG COMPOSER_VERSION=1.10.22

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="Debisn Slim Docherfile including Nginx, PHP-FPM, SSH"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/nginx-php71"

RUN apt install -y php$PHP_VERSION-sodium

RUN curl -sS https://getcomposer.org/installer | php -- \
    --version=${COMPOSER_VERSION} \
    --install-dir=/usr/bin --filename=composer

RUN apt clean && apt autoremove --yes && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*