FROM alpine:latest

RUN apk --update add nginx php7 php7-fpm php7-opcache php7-session php7-json php7-pdo_sqlite php7-openssl curl supervisor

COPY nginx-default.conf /etc/nginx/conf.d/default.conf

RUN wget -O /tmp/dokuwiki.tgz https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
RUN cd / && mkdir /dokuwiki && tar -xzf /tmp/dokuwiki.tgz -C /dokuwiki --strip-components 1 && rm -f /tmp/dokuwiki.tgz

RUN sed -i 's#user = nobody#user = nginx#' /etc/php7/php-fpm.d/www.conf && \
	sed -i 's#group = nobody#group = nginx#' /etc/php7/php-fpm.d/www.conf && \
	mkdir /run/nginx/ && \
	chown -R nginx:nginx /dokuwiki

EXPOSE 80
WORKDIR /dokuwiki

COPY supervisord.conf /etc

CMD ["/usr/bin/supervisord"]