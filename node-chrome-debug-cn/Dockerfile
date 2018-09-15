FROM selenium/node-chrome-debug
MAINTAINER Wu Jiansong <360517703@163.com>
USER root

RUN apt-get update -qqy \
    && apt-get -qqy install ttf-wqy-microhei ttf-wqy-zenhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

USER seluser