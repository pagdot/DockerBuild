FROM lsiobase/alpine:3.11

RUN apk add --no-cache nodejs npm && npm install -g tiddlywiki

COPY root/ /

ENV TIDDLYWIKI_PLUGIN_PATH=/config/plugins
ENV TIDDLYWIKI_THEME_PATH=/config/themes

VOLUME /config /data

WORKDIR /data