FROM debian:stable-slim AS build-env
MAINTAINER niku

WORKDIR /app

ENV LANG=C.UTF-8 \
    NWIKI_REPO=https://github.com/niku/nikulog \
    NWIKI_SITE_NAME="ヽ（´・肉・｀）ノログ" \
    NWIKI_TAGLINE="How do we fighting without fighting?" \
    NWIKI_ENDPOINT="http://niku.name/" \
    NWIKI_TRACKING_ID=UA-26456277-1

RUN BUILD_DEPS="git ruby ruby-bundler rake ruby-rugged ruby-nokogiri" && \
    apt-get update -qq && \
    apt-get install --no-install-recommends --no-install-suggests -y $BUILD_DEPS

RUN git clone https://github.com/niku/nwiki.git

WORKDIR /app/nwiki

RUN bundle install --jobs 4

COPY . /app/nwiki/tmp

RUN bundle exec rake \
        nwiki:convert \
        nwiki:add_metadata \
        nwiki:generate_index \
        nwiki:add_highlightjs \
        nwiki:add_analytics

FROM nginx:stable

ENV LANG=C.UTF-8

COPY --from=build-env /app/nwiki/conf/niku.name.conf /etc/nginx/conf.d/default.conf
COPY --from=build-env /app/nwiki/tmp/ /usr/share/nginx/html/
