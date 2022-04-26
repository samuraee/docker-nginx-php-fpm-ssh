# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION

FROM aboozar/nginx-php-base:$PHP_VERSION

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="My aravel queue container"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/my-laravel-queue"

ARG NONROOT_USER=scorpion

# add any customization you need
COPY php/modules.ini /etc/php/${PHP_VERSION}/mods-available/modules.ini

# specify container's processes
COPY container/queue-px.conf /etc/supervisor/conf.d/queue-px.conf

EXPOSE 2222

WORKDIR /var/www/

# change container to non-root mode
USER $NONROOT_USER
