# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION

FROM aboozar/nginx-php:$PHP_VERSION

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="My aravel queue container"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/my-laravel-queue"


# Configure custom things

COPY ssh/sshd_config /etc/ssh/sshd_config
COPY php/pool.conf /etc/php/7.1/fpm/pool.d/www.conf
COPY container/queue-px.conf /etc/supervisor/conf.d/queue-px.conf

EXPOSE 2222

WORKDIR /var/www/

# change container to non-root mode
USER nazgul
