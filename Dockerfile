FROM martialblog/limesurvey:6-apache@sha256:a024fe42676f1e6c3d90046e62ebf9f01a174a5e8f423150157a23ebbbeb319b
USER root
RUN apt update && apt install -y git && \
    cd ./plugins/ && \
    git clone https://github.com/SondagesPro/limesurvey-oauth2.git AuthOAuth2 && \
    cd AuthOAuth2 && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer install
USER www-data