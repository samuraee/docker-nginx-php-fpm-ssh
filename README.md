# nginx-php-fpm

## About

Nginx + PHP-FPM + SSH Docker image by [Samuraee](https://github.com/samuraee).

Compatible for Laravel concepts

## Usage
Arguments:
```
- PHP_VERSION          [null|71, 72]
```

Enviroment variables:
```
- TZ                   example: Asia/Tehran
- ENTRYPOINT           [null|web, schedule_run, workers] see entrypoint.sh for more details
- SSH_AUTHORIZED_KEYS  /root/.ssh/authorized_keys file content
```

Build
```
docker build -f 71/Dockerfile -t aboozar/php-7.1 .
```

Run
```
docker run --name php71-container -p 22 -p 80 aboozar/nginx-php-fpm-ssh
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
