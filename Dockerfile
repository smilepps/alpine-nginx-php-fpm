FROM smileps/alpine-runit:latest
RUN docker-php-ext-install pdo_pgsql
MAINTAINER Mohammad Abdoli Rad <m.abdolirad@gmail.com>

LABEL org.label-schema.name="alpine-nginx-php-fpm" \
        org.label-schema.vendor="Dockage" \
        org.label-schema.description="Docker Nginx & PHP-FPM image built on Alpine Linux" \
        org.label-schema.vcs-url="https://github.com/dockage/alpine-nginx-php-fpm" \
        org.label-schema.license="MIT"

ENV DOCKAGE_WEBROOT_DIR=/var/www \
    DOCKAGE_DATA_DIR=/data \
    DOCKAGE_ETC_DIR=/etc/dockage \
    DOCKAGE_LOG_DIR=/var/log

ADD ./assets ${DOCKAGE_ETC_DIR}

RUN apk update \
    && apk --no-cache add nginx php7-fpm \
    && runit-enable-service nginx \
    && runit-enable-service php-fpm \
    && chown nginx:nginx ${DOCKAGE_WEBROOT_DIR} \
    && mv ${DOCKAGE_ETC_DIR}/sbin/* /sbin \
    && rm -rf /var/cache/apk/* ${DOCKAGE_ETC_DIR}/sbin ${DOCKAGE_WEBROOT_DIR}/* \
    && ln -s /usr/bin/php-fpm7 /usr/bin/php-fpm

EXPOSE 80/tcp 443/tcp

VOLUME ["$DOCKAGE_DATA_DIR", "$DOCKAGE_LOG_DIR"]
WORKDIR ${DOCKAGE_WEBROOT_DIR}

ENTRYPOINT ["/sbin/entrypoint"]
CMD ["app:start"]
