ARG LIMESURVEY_BASE=martialblog/limesurvey:6-apache@sha256:a024fe42676f1e6c3d90046e62ebf9f01a174a5e8f423150157a23ebbbeb319b

# Build the plugin in a throwaway stage so the runtime image stays smaller.
FROM ${LIMESURVEY_BASE} AS plugin-builder

USER root
WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth=1 https://github.com/SondagesPro/limesurvey-oauth2.git plugins/AuthOAuth2 \
    && curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php \
    && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-setup.php \
    && composer install \
        --working-dir=/var/www/html/plugins/AuthOAuth2 \
        --no-dev \
        --no-interaction \
        --prefer-dist \
        --optimize-autoloader \
    && rm -rf /var/www/html/plugins/AuthOAuth2/.git \
    && rm -rf /root/.composer

FROM ${LIMESURVEY_BASE}

USER root
WORKDIR /var/www/html

COPY --from=plugin-builder --chown=www-data:www-data /var/www/html/plugins/AuthOAuth2 /var/www/html/plugins/AuthOAuth2

USER www-data
