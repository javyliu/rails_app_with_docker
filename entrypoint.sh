#!/bin/sh
set -e
bundle check || bundle config disable_platform_warnings true \
    && bundle config set --local path '/usr/local/tmp_bundle' \
    && bundle install -j4 --retry 3


rm -f /app/tmp/pids/server.pid

exec "$@"
