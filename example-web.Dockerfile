# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION

FROM aboozar/nginx-php-base:$PHP_VERSION

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="My Laravel app container"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/my-sample-app"

# change container to non-root mode
USER $NONROOT_USER

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/vhost.conf /etc/nginx/sites-enabled/default

# add any customization you need
COPY php/pool.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY php/modules.ini /etc/php/${PHP_VERSION}/mods-available/modules.ini

# specify container's processes
COPY container/web-px.conf /etc/supervisor/conf.d/web-px.conf

EXPOSE 2222 8080

WORKDIR /var/www/

# change container to non-root mode
USER $NONROOT_USER