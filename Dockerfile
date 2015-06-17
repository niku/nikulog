FROM niku/nwiki
MAINTAINER niku

RUN git clone https://github.com/niku/nikulog /var/www/nikulog && \
    cd /var/www/nikulog && \
    git checkout config && \
    git checkout master && \
    git fetch && \
    git reset --hard origin/master && \
    echo "\$LOAD_PATH << './lib'\nrequire './lib/nwiki'\nrequire 'rack/tracker'\nuse Rack::Tracker do\n  handler :google_analytics, { tracker: 'UA-26456277-1' }\nend\nrun Nwiki::Frontend::App.new File.expand_path('../../nikulog/.git', __FILE__)" > /var/www/nwiki/config.ru && \
    mkdir -p /var/www/nikulog/tmp && \
    touch /var/www/nikulog/tmp/restart.txt
