# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION

FROM aboozar/nginx-php:$PHP_VERSION

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="My Sample app container"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/my-laravel-queue"


# Configure custom things

COPY app/ssh/sshd_config /etc/ssh/sshd_config
COPY container/cron-px.conf /etc/supervisor/conf.d/cron-px.conf

# Configure cron jobs and ensure crontab-file permissions
COPY cron.d /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*

EXPOSE 2222

WORKDIR /var/www/

# change container to non-root mode
USER nazgul
