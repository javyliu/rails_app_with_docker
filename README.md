# README

使用ruby:alpine 布署一个docker开发环境

步骤如下:

* 新建一个空文件夹 如：app

* 创建Dockerfile 文件

* 新建一个Gemfile文件，只加入 rails ， 用来创建rails应用

* 新建一个空的Gemfile.lock文件，touch Gemfile.lock

* 新建入口文件 entrypoint.sh

* 新建docker-compose.yml 文件，用来配置相应docker服务

* 执行 
```shell
 docker-compose run --no-deps --rm web bundle exec rails new . --force --database=postgresql -B
```
通过容器创建一个rails应用， --no-deps 表示不启动依赖服务

* 创建应用后会得到一个新的Gemfile 及 Gemfile.lock 文件，更改gem source 为 https://gems.ruby-china.com 后重新编译

```shell
 docker-compose build
```

* 更改database.yml 文件 然后执行
```shell
 docker-compose run --rm web bundle exec rails:webpacker:install
 docker-compose run --rm web bundle exec rails db:create
```

# 最后启动应用
```shell
 docker-compose up 
```

## 注
