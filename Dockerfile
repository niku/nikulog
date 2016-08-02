FROM nginx
MAINTAINER niku

WORKDIR /var/tmp

ENV LANG=C.UTF-8 \
    NWIKI_REPO=https://github.com/niku/nikulog \
    NWIKI_SITE_NAME="ヽ（´・肉・｀）ノログ" \
    NWIKI_TAGLINE="How do we fighting without fighting?" \
    NWIKI_ENDPOINT="http://niku.name/" \
    NWIKI_TRACKING_ID=UA-26456277-1

RUN BUILD_DEPS="git bundler rake ruby-dev build-essential cmake pkg-config libssl-dev libssh-dev" && \
    apt-get update -qq && \
    apt-get install --no-install-recommends --no-install-suggests -y $BUILD_DEPS && \
    git clone https://github.com/niku/nwiki.git && \
    cd nwiki && \
    sed -i -e 's/"bundler".*$/"bundler"/g' nwiki.gemspec && \
    bundle install --path vendor/bundle --jobs 4 && \
    bundle exec rake \
        nwiki:get_head \
        nwiki:convert \
        nwiki:add_metadata \
        nwiki:generate_index \
        nwiki:add_highlightjs \
        nwiki:add_analytics \
        && \
    cp conf/niku.name.conf /etc/nginx/conf.d/default.conf && \
    cp -pr tmp/* /usr/share/nginx/html && \
    cd .. && \
    apt-get purge --auto-remove -y $BUILD_DEPS && \
    apt-get clean && \
    rm -rf \
       /var/cache/apt/archives/* \
       /var/lib/apt/lists/* \
       nwiki
