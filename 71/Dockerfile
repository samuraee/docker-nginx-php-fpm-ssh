FROM centos:centos7

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="Nginx with PHP-FPM Docker Image"
LABEL Version="20210921"

# You can use version 71 or 72
ARG PHP_VERSION=71
ENV TZ "Asia/Tehran"
ENV SSH_AUTHORIZED_KEYS ""

# Enable Networking
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Install EPEL & REMI
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm \
    && yum-config-manager --enable epel \
    && yum-config-manager --enable remi-php${PHP_VERSION}


# Install PHP and Tools
RUN yum -y install --setopt=tsflags=nodocs openssh-server openssh-clients \
    composer \
    php-bcmath \
    php-cli \
    php-common \
    php-fpm \
    php-gd \
    php-gmp \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache \
    php-pdo \
    php-pdo_pgsql \
    php-pecl-apcu \
    php-pecl-grpc \
    php-process \
    php-soap \
    php-sodium \
    php-xml \
    php-xmlwriter \
    php-xmlrpc \
    php-zip\
    newrelic-php5 \
    nginx \
    nodejs \
    cronie \
    rsync \
    git \
    vim \
    htop \
    mtr \
    supervisor \
    telnet \
    links \
	gettext \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa <<<y >/dev/null 2>&1
RUN ssh-keygen -A

RUN ls -lash /root/

# Configure things
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && sed -i -e 's~^;date.timezone =$~date.timezone = ${TZ}~g' /etc/php.ini \
    && mkdir -p /etc/nginx/conf.d/000-default \
    && mkdir -p /var/www \
    && mkdir -p /var/www/.well-known \
    && mkdir -p /run/php-fpm \
    && mkdir -p /var/cache/nginx/fastcgi \
    && chown nobody:nobody /var/lib/php -R \
    && chown nobody:nobody /var/cache/nginx -R \
    && chown nobody:nobody /var/lib/nginx -R \
    && echo '<?php phpinfo(); ?>' > /var/www/index.php \
    && cp /etc/newrelic/newrelic.cfg.template /etc/newrelic/newrelic.cfg \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && chown -R nobody /var/log/newrelic/ \
    && echo "${SSH_AUTHORIZED_KEYS}" > /root/.ssh/authorized_keys && chown 600 /root/.ssh/authorized_keys


COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/vhost.conf /etc/nginx/conf.d/000-default/vhost.conf
COPY pool.conf /etc/php-fpm.d/www.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY container-px.ini /etc/supervisord.d/container-px.ini

EXPOSE 80 22

WORKDIR /var/www/

CMD ["/usr/local/bin/entrypoint.sh"]
