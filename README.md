# nginx-php-fpm

## About

Nginx + PHP-FPM + SSH Docker image by [Samuraee](https://github.com/samuraee).

## Usage
enviroment variables:
- TZ
- SSH_AUTHORIZED_KEYS

```
docker exec -p 80:80 samuraee/nginx-php-fpm-ssh
```

## Handy Paths

* nginx include: /etc/nginx/conf.d/*/*.conf
* nginx vhosts' webroots: /var/www/
* nginx logs: /dev/stdout or /var/log/nginx/

Ideally the above ones should be mounted from docker host
and container nginx configuration (see vhost.conf for example),
site files and place to right logs to.

Both php-fpm and nginx run under nobody inside the container

Exposes port 80 for nginx.
