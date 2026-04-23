FROM martialblog/limesurvey:latest
USER root
RUN apt update && apt install -y git && \
    cd ./plugins/ && \
    git clone https://github.com/SondagesPro/limesurvey-oauth2.git AuthOAuth2 && \
    cd AuthOAuth2 && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer install
USER www-data