# PHP base image

This repository contains the definition of the base image that we use for our Apache-PHP projects.

## Php.ini settings
This image provides a way to ovverride certain php.ini settings through some env vars

Expample:
```bash
$ docker run -d -e "PHP_MEMORY_LIMIT=128M" treedom/php-apache
```

The overridable settings have the following default values

| Variable | Default value |
|--------|--------|
| TIMEZONE | Europe/Rome |
| PHP_MEMORY_LIMIT | 512M |
| MAX_UPLOAD | 50M |
| PHP_MAX_FILE_UPLOAD | 200 |
| PHP_MAX_POST | 100M |

## Allow override toggle

If you need to enable mod-rewrite and the "AllowOverride All" apache directive, do:
```bash
$ docker run -d -e "ALLOW_OVERRIDE=true" treedom/php-apache
```

## Code placement

You are supposed to place your codebase in the `/app` folder, since Apache will consider that as the `DocumentRoot`

If you need to set a subfolder of your app as the `DocumentRoot` you can do:
```bash
$ docker run -d -e "DOC_ROOT=web" treedom/php-apache
# Now Apache will consider DocumentRoot = /app/web
```

**NOTE:** Pass the `$DOC_ROOT` value **without** leading `/`

