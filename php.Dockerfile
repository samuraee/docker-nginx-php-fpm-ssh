# Debian version buster, bullseye
# Use buster for PHP <= 7.3 and bullseye for PHP >= 7.4
ARG DEBIAN_VERSION

FROM aboozar/debian-slim-apt:${DEBIAN_VERSION}

# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION
ARG COMPOSER_VERSION=2.1.6

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="Debisn Slim Docherfile including Nginx, PHP-FPM"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/nginx-php-base:${PHP_VERSION}"

RUN wget -O- https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list

RUN apt update

RUN apt update && apt install -y --no-install-recommends php${PHP_VERSION} \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-gmp \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysqlnd \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlwriter \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-zip \
    php-pear \
    g++ \
    make

RUN pecl channel-update pecl.php.net \
    && pecl install grpc apcu protobuf

# because Sodium is supported natively by PHP 7.2+
RUN if [ "$PHP_VERSION" = "7.1" ] ; \
    then apt install -y --no-install-recommends php${PHP_VERSION}-sodium php${PHP_VERSION}-mcrypt; \
    else pecl install mcrypt; \
    fi

RUN curl -sS https://getcomposer.org/installer | php -- \
    --version=${COMPOSER_VERSION} \
    --install-dir=/usr/bin --filename=composer

RUN apt clean \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*