FROM ruby:3.0

ARG app_root=/app




WORKDIR $app_root

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

COPY Gemfile* ./

RUN bundle install

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bundle","exec","rails", "s", "-b", "0.0.0.0"]

