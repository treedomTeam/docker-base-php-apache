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

# Fix ownerships
main() {
    local owner group owner_id group_id tmp
    read owner group owner_id group_id < <(stat -c '%U %G %u %g' .)
    if [[ $owner = UNKNOWN ]]; then
        owner=$(randname)
        if [[ $group = UNKNOWN ]]; then
            group=$owner
            addgroup --system --gid "$group_id" "$group"
        fi
        adduser --system --uid=$owner_id --gid=$group_id "$owner"
    fi
    tmp=/tmp/$RANDOM
    {
        echo "User $owner"
        echo "Group $group"
        grep -v '^User' /etc/apache2/apache2.conf |
            grep -v '^Group'
    } >> "$tmp" &&
    cat "$tmp" > /etc/apache2/apache2.conf &&
    # cat "$tmp" > /test.txt
    rm "$tmp"
    # Not volumes, so need to be chowned
    chown -R "$owner:$group" /var/{lock,log,run}/apache*

    exec "$@"
}

randname() {
    local -x LC_ALL=C
    tr -dc '[:lower:]' < /dev/urandom |
        dd count=1 bs=16 2>/dev/null
}

main "$@"
