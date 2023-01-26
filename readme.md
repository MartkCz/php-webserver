# PHP 8.1.14 + nginx alpine 

https://hub.docker.com/repository/docker/martkcz/php-webserver

# Nginx modules

usage in Dockerfile:
```dockerfile
RUN nginx-enable <name>
```

**cache** - enables http cache for 1 year \
**no-www** - redirects url from www.* to * \
**https** - redirects url to https

## Setup project in Dockerfile

Nette framework
```dockerfile
RUN setup nette
```

PHP default production values
```dockerfile
RUN setup php-production
```

PHP options
```dockerfile
RUN setup php memory_limit 64M
```

## Production dockerfile

```dockerfile
FROM composer AS composer
COPY / /app

RUN composer install \
  --optimize-autoloader \
  --no-interaction \
  --no-progress

FROM martkcz/php-webserver
COPY --chown=nginx --from=composer /app /app
```
