#!/usr/bin/env bash

echo "Block until postgres accepts connections..."

retry=0
success=false
until [ $retry -ge 10 ]; do
  psql -c '\q' && success=true

  if [ "$success" = true ]; then
    echo "Postgres is available."
    break
  fi

  echo "Postgres is unavailable ($n) - sleeping..."
  retry=$[$retry+1]
  sleep 1
done
