# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION

FROM aboozar/nginx-php:$PHP_VERSION

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="My Laravel cron container"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/my-laravel-ron"


# Configure custom things

COPY app/ssh/sshd_config /etc/ssh/sshd_config

# add any customization you need
COPY php/opcache.conf /etc/php/${PHP_VERSION}/mods-available/opcache.conf

# specify container's processes
COPY container/cron-px.conf /etc/supervisor/conf.d/cron-px.conf

# Configure cron jobs and ensure crontab-file permissions
COPY cron.d /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*

EXPOSE 2222

WORKDIR /var/www/

# change container to non-root mode
USER nazgul
