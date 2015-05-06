FROM niku/nwiki
MAINTAINER niku

RUN git clone https://github.com/niku/nikulog /var/www/nikulog && \
    cd /var/www/nikulog && \
    git checkout config && \
    echo "\$LOAD_PATH << './lib'\nrequire './lib/nwiki'\n\nrun Nwiki::Frontend::App.new File.expand_path('../../nikulog/.git', __FILE__)" > /var/www/nwiki/config.ru
