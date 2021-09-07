# nginx-php-fpm-ssh

## About

Nginx + PHP-FPM + SSH Docker image by [Samuraee](https://github.com/samuraee).

Compatible for Laravel concepts


All processes through this container handled by using Supervisord.
You can deploy every service by customizing supervisor config files like what you can see in container folder

## Usage
Arguments:
```
- DEBIAN_VERSION       eg, buster, bullseye
- PHP_VERSION          eg, 7.1, 7.2, 7..3, 7.4
- COMPOSER_VERSION     eg, 1.10.22, 2.1.6, stable
```

## Enviroment variables:
```
- TZ                   eg: Asia/Tehran
- SSH_AUTHORIZED_KEYS  /root/.ssh/authorized_keys file content
```

## STEP 1: Build Os image based on Debian
This image included sshd, nginx and also nodejs from official apt repository

### build debian 10 buster
```bash
docker build --build-arg DEBIAN_VERSION=buster \
    -f debian.Dockerfile \
    -t aboozar/debian-slim-apt:buster .
```
### build debian 11 bullseye
```bash
docker build --build-arg DEBIAN_VERSION=bullseye \
    -f debian.Dockerfile \
    -t aboozar/debian-slim-apt:bullseye .
```

## STEP 2: Build PHP base image

Available Debian versions: buster, bullseye
 - Use buster for PHP <= 7.3 and bullseye for PHP >= 7.4

Available PHP versions: 7.1, 7.2, 7.3, 7.4
```
docker build --build-arg PHP_VERSION=7.1 \
    --build-arg DEBIAN_VERSION=buster \
    --build-arg COMPOSER_VERSION=1.10.22 \
    -f php.Dockerfile \
    -t aboozar/nginx-php-base:7.1 .
```

# Run final application container

## Config files:
First of fill the folloewing files based on your desired configs
```
/etc/ssh/sshd_config
/etc/nginx/nginx.conf
/etc/nginx/sites-enabled/default
/etc/php/7.1/fpm/pool.d/www.conf
/etc/supervisord.d/web-px.ini    # for web container
/etc/supervisord.d/cron-px.ini   # for cron container
/etc/supervisord.d/queue-px.ini  # for queue container
```

Ideally the above ones should be mounted from docker host
and container nginx configuration (see vhost.conf for example),
site files and place to right logs to.


## sample laravel Dockerfile (web contaner) with PHP 7.1

See `example-web.Dockerfile`

```
FROM aboozar/nginx-php-base:7.1

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="SMSator container"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/my-laravel"


# # Configure things

COPY deploy/app/ssh/sshd_config /etc/ssh/sshd_config
COPY deploy/app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY deploy/app/nginx/vhost.conf /etc/nginx/sites-enabled/default
COPY deploy/app/php/pool.conf /etc/php/7.1/fpm/pool.d/www.conf

COPY deploy/app/container/web-px.conf /etc/supervisor/conf.d/container-px.conf

EXPOSE 2222 8080

WORKDIR /var/www/

# Change container to non-root user mode, it's not mandatory
USER nazgul
```
