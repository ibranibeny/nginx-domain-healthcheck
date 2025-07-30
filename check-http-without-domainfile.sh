#!/bin/bash

# === Configuration ===
PORT=${PORT:-443}

# List of domains to check (hardcoded)
DOMAINS=(
  example.com
  anotherdomain.com
  internal.service.local
)

# === Health check loop ===
while true; do
  for domain in "${DOMAINS[@]}"; do
    echo "[$(date)] Checking http://$domain:$PORT ..."

    # Use HTTPS if PORT is 443, otherwise HTTP
    if [ "$PORT" -eq 443 ]; then
      curl -k -s --head --connect-timeout 5 "https://$domain:$PORT" > /dev/null
    else
      curl -s --head --connect-timeout 5 "http://$domain:$PORT" > /dev/null
    fi

    if [ $? -ne 0 ]; then
      echo "[$(date)] HTTP(S) check FAILED for $domain. Attempting NGINX reload..."

      pid=$(pidof nginx)
      if [ -n "$pid" ]; then
        nginx -s reload
      else
        echo "[$(date)] NGINX not running. Starting nginx..."
        /usr/sbin/nginx
      fi
    else
      echo "[$(date)] HTTP(S) check OK for $domain"
    fi
  done

  sleep 30
done

