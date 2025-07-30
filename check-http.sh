#!/bin/bash

DOMAIN_FILE=${DOMAIN_FILE:-/etc/nginx/domains.txt}
PORT=${PORT:-443}

if [ ! -f "$DOMAIN_FILE" ]; then
  echo "[$(date)] Domain file $DOMAIN_FILE not found!"
  exit 1
fi

while IFS= read -r domain; do
  [ -z "$domain" ] && continue

  echo "[$(date)] Checking https://$domain:$PORT ..."
  curl -s --head --connect-timeout 5 "https://$domain:$PORT" > /dev/null

  if [ $? -ne 0 ]; then
    echo "[$(date)] HTTP check FAILED for $domain. Attempting NGINX reload..."

    pid=$(pidof nginx)
    if [ -n "$pid" ]; then
      nginx -s reload
    else
      echo "[$(date)] NGINX not running. Starting nginx..."
      /usr/sbin/nginx
    fi
  else
    echo "[$(date)] HTTP check OK for $domain"
  fi
done < "$DOMAIN_FILE"
