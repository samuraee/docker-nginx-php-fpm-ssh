# nginx-php-fpm-ssh

## About

Nginx + PHP-FPM + SSH Docker image by [Samuraee](https://github.com/samuraee).

Compatible for Laravel concepts

## Usage
Arguments:
```
- PHP_VERSION          [null|7.1, 7.2, 7..3, 7.4]
```

Enviroment variables:
```
- TZ                   example: Asia/Tehran
- ENTRYPOINT           [null|web, schedule_run, workers] see entrypoint.sh file for more details
- SSH_AUTHORIZED_KEYS  /root/.ssh/authorized_keys file content
```

## Build Os image based on Debian
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

## Build PHP base image

Available Debian versions: buster, bullseye
 - Use buster for PHP <= 7.3 and bullseye for PHP >= 7.4

Available PHP versions: 7.1, 7.2, 7.3, 7.4
```
docker build --build-arg PHP_VERSION=7.1 \
    --build-arg DEBIAN_VERSION=buster \
    -f php.Dockerfile \
    -t aboozar/nginx-php-base:7.1 .
```

## Build PHP 7.1, 7.2, 7.3 final image
This image included latest php 7.[1,2,3] and you can choose composer version by
[COMPOSER_VERSION](https://getcomposer.org/download/) env

Find `php71.Dockerfile` file to see the installed php modules
```bash
docker build --build-arg PHP_VERSION=7.1 \
    --build-arg DEBIAN_VERSION=buster \
    --build-arg COMPOSER_VERSION=1.10.22 \
    -f php71.Dockerfile \
    -t aboozar/nginx-php:7.1 .

docker build --build-arg PHP_VERSION=7.2 \
    --build-arg DEBIAN_VERSION=buster \
    --build-arg COMPOSER_VERSION=2.1.6 \
    -f php72.Dockerfile \
    -t aboozar/nginx-php:7.2 .

docker build --build-arg PHP_VERSION=7.3 \
    --build-arg DEBIAN_VERSION=buster \
    --build-arg COMPOSER_VERSION=stable \
    -f php73.Dockerfile \
    -t aboozar/nginx-php:7.3 .
```

## Build PHP 7.4 final image
This image included latest php 7.4 and latest composer 2 version
Find `php74.Dockerfile` fto see the installed php modules
```
docker build --build-arg PHP_VERSION=7.4 \
    --build-arg DEBIAN_VERSION=bullseye \
    --build-arg COMPOSER_VERSION=stable \
    -f php74.Dockerfile \
    -t aboozar/nginx-php:7.4 .
```

# Run final application container

## Handy Paths
* nginx include: /etc/nginx/sites-enabled/*.*
* nginx vhosts' webroots: /var/www/public
* nginx logs: /dev/stdout or /var/log/nginx/

Ideally the above ones should be mounted from docker host
and container nginx configuration (see vhost.conf for example),
site files and place to right logs to.

## Config files:
First of fill the folloewing files based on your desired configs
```
/etc/ssh/sshd_config
/etc/nginx/nginx.conf
/etc/nginx/sites-enabled/default
/etc/php/7.1/fpm/pool.d/www.conf
/usr/local/bin/entrypoint.sh
/etc/supervisord.d/web-px.ini # for web
/etc/supervisord.d/queue-px.ini # for queu
```
## Run web container

```
docker run --build-arg ENTRYPOINT=web \
    --name my-web-container \
    -p 2222:2222 \
    -p 8080:8080 \
    aboozar/nginx-php:7.1
```

## Run Laravel schedule_run container

```
docker run --build-arg ENTRYPOINT=schedule_run \
    --name my-schdl-container \
    -p 2222:2222 \
    aboozar/nginx-php:7.1
```

## Run web container

```
docker run --build-arg ENTRYPOINT=workers \
    --name my-q-container \
    -p 2222:2222 \
    aboozar/nginx-php:7.1
```


Both php-fpm and nginx run under `nazgul` inside the container

Exposes port 8080 for nginx and 2222 for ssh
