#!/bin/bash

echo "ServerName localhost" >> /etc/apache2/apache2.conf
sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|" /etc/php5/apache2/php.ini
sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /etc/php5/apache2/php.ini
sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /etc/php5/apache2/php.ini
sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /etc/php5/apache2/php.ini
sed -i "s|post_max_size =.*|max_file_uploads = ${PHP_MAX_POST}|" /etc/php5/apache2/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/apache2/php.ini

if [ "$DOC_ROOT" = "@false@" ]; then
    unset DOC_ROOT
else
    sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/html/${DOC_ROOT}|" /etc/apache2/sites-available/000-default.conf
fi

exec "$@"
