#!/usr/bin/env sh

php_ini="/etc/php81/conf.d/custom.ini"
nginx_default_file="/etc/nginx/conf.d/default.conf"
nginx_file="/etc/nginx/nginx.conf"

function replace_php_ini() {
  search="$1\s*=[^\n]+"
  replace="$1 = $2"

  grep -qE "$search" "$php_ini"

  if [ $? -ne 0 ]; then
    echo "Cannot find $1 in $php_ini"
    exit 1
  fi

#  sed -r "s;$search;$replace;g" "$php_ini"
  sed -ri "s;$search;$replace;g" "$php_ini"
}

function replace_nginx_conf() {
  search="$1\s+[^;]+"
  replace="$1 $2"

  grep -qE "$search" "$nginx_file"

  if [ $? -ne 0 ]; then
    echo "Cannot find $1 in $nginx_file"
    exit 1
  fi

#  sed -r "s;$search;$replace;g" "$nginx_file"
  sed -ri "s;$search;$replace;g" "$nginx_file"
}

case $1 in
  "nette")
    rm -r /app/public
    sed -i 's/root \/app\/public;/root \/app\/www;/g' $nginx_default_file
  ;;
  "php-production")
    replace_php_ini "memory_limit" "64M"
    replace_php_ini "post_max_size" "32M"
    replace_php_ini "upload_max_filesize" "32M"

    replace_php_ini "display_errors" "Off"
    replace_php_ini "display_startup_errors" "Off"
    replace_php_ini "report_memleaks" "Off"

    replace_php_ini "opcache.validate_timestamps" "0"
  ;;
  "php")
    if [ -z $2 ]; then
      echo "Missing second argument of setup php"
    fi

    if [ -z $3 ]; then
      echo "Missing third argument of setup php"
    fi

    replace_php_ini "$2" "$3"
  ;;
  "nginx")
    if [ -z $2 ]; then
          echo "Missing second argument of setup nginx"
    fi

    if [ -z $3 ]; then
      echo "Missing third argument of setup nginx"
    fi

    replace_nginx_conf "$2" "$3"
  ;;
  *)
    echo "Unknown argument '$1'"
    exit 1
  ;;
esac
