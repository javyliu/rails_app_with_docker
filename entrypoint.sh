#!/bin/sh
set -e
bundle check || bundle install -j4 --retry 3


rm -f /app/tmp/pids/server.pid

exec "$@"
