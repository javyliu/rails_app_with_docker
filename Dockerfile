FROM  ruby:alpine

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git yarn"
ARG DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev nodejs"
ARG RUBY_PACKAGES="tzdata imagemagick"
ARG font_path="/usr/share/fonts/Type1"

ENV RAILS_ENV=development
ENV NODE_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"


WORKDIR $RAILS_ROOT

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache  $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES \
    && mkdir -p $font_path && cd $font_path \
    && wget https://dl.freefontsfamily.com/download/Helvetica-Font \
    && unzip Helvetica-Font \
    && rm Helvetica-Font

COPY Gemfile* ./
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


RUN mkdir -p $RAILS_ROOT/vendor/bundle \
    && bundle config disable_platform_warnings true \
    && bundle config set --local path '$RAILS_ROOT/vendor/bundle' \
    && bundle install -j4 --retry 3

#生产环境时可用
#RUN bundle config --global frozen 1 \
#    && bundle config disable_platform_warnings true \
#    && bundle config set --local path 'vendor/bundle' \
#    && bundle install -j4 --retry 3
#    && bundle config set --local without 'development:test:assets'\
#    && rm -rf vendor/bundle/ruby/3.0.0/cache/*.gem \
#    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.c" -delete \
#    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.o" -delete



EXPOSE 3000

CMD ["bundle","exec","rails", "s", "-b", "0.0.0.0"]
