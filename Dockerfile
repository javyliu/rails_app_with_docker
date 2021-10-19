FROM  ruby:alpine

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git bash yarn"
ARG DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev nodejs"
ARG RUBY_PACKAGES="tzdata imagemagick"

ENV RAILS_ENV=development
ENV NODE_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"


WORKDIR $RAILS_ROOT

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache  $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES
    #&& gem update --system

COPY Gemfile* ./
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


RUN bundle config disable_platform_warnings true \
    && bundle config set --local path '/app/vendor/bundle' \
    && bundle install -j4 --retry 3

#RUN bundle config --global frozen 1 \
#    && bundle config disable_platform_warnings true \
#    && bundle config set --local path 'vendor/bundle' \
#    && bundle install -j4 --retry 3
    #&& bundle config set --local without 'development:test:assets'\
    #&& rm -rf vendor/bundle/ruby/3.0.0/cache/*.gem \
    #&& find vendor/bundle/ruby/3.0.0/gems/ -name "*.c" -delete \
    #&& find vendor/bundle/ruby/3.0.0/gems/ -name "*.o" -delete



EXPOSE 3000

CMD ["bundle","exec","rails", "s", "-b", "0.0.0.0"]
