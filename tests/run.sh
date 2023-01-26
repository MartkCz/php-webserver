#!/usr/bin/env sh

BASEDIR=$(dirname "$0")

function test_case() {
  echo -e "\033[0;33m$1\033[0;0m"

  "${@:2}"

  if [ 0 -ne "$?" ]; then
    echo -e "\033[0;31mTest failed.\033[0;0m"
  fi
}

docker container run --rm -v "$(pwd)/$BASEDIR:/app/public" "$1" php iconv.php

test_case "Check if file /app/public/index.html exists." docker container run --rm "$1" test -f /app/public/index.html
