# nginx-php-fpm

## About

Nginx + PHP-FPM Docker image by [Samuraee](https://github.com/samuraee).

Compatible for Laravel concepts


All processes through this container handled by using Supervisord.
You can deploy every service by customizing supervisor config files like what you can see in container folder

## Usage
Arguments:
```
- NONROOT_USER         eg, scorpion
- DEBIAN_VERSION       eg, buster, bullseye
- PHP_VERSION          eg, 7.1, 7.2, 7..3, 7.4
- COMPOSER_VERSION     eg, 1.10.22, 2.1.6, stable
```

## Enviroment variables:
```
- TZ                   eg: Asia/Tehran
```

## STEP 1: Build Os image based on Debian
This image included nginx and also nodejs from official apt repository

### build debian 10 buster
```bash
docker build --build-arg DEBIAN_VERSION=buster \
    --build-arg NONROOT_USER=scorpion \
    -f debian.Dockerfile \
    -t aboozar/debian-slim-apt:buster .
```
### build debian 11 bullseye
```bash
docker build --build-arg DEBIAN_VERSION=bullseye \
    --build-arg NONROOT_USER=scorpion \
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
    --build-arg NONROOT_USER=scorpion \
    -f php.Dockerfile \
    -t aboozar/nginx-php-base:7.1 .
```

# Run final application container

## Config files:
First of fill the folloewing files based on your desired configs
```
/etc/nginx/nginx.conf
/etc/nginx/sites-enabled/default
# php-fpm config
/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
# php modules
/etc/php/${PHP_VERSION}/mods-available/modules.conf
/etc/supervisord.d/web-px.ini    # for web container
/etc/supervisord.d/cron-px.ini   # for cron container
/etc/supervisord.d/queue-px.ini  # for queue container
```

Ideally the above ones should be mounted from docker host
and container nginx configuration (see vhost.conf for example),
site files and place to right logs to.


## Sample laravel app Dockerfile (web contaner) with PHP 7.1

See `example-web.Dockerfile`

## Sample laravel queue Dockerfile (queue contaner) with PHP 7.1

See `example-queue.Dockerfile`

## Sample laravel cron Dockerfile (cron contaner) with PHP 7.1

See `example-cron.Dockerfile`