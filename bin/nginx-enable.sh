#!/usr/bin/env sh

file="/etc/nginx/conf.m/$1.conf"
target="/etc/nginx/conf.d/$1.conf"

if [ ! -f $file ]; then
  echo "Nginx module $1 does not exist."
  exit 1
fi

if [ -f $target ]; then
  echo "Config $target already exists."
  exit 1
fi

cp $file $target
