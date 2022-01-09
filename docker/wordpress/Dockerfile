ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache
LABEL maintainer="Walmir Silva <walmir.design@gmail.com>"

# persistent dependencies
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  # Ghostscript is required for rendering PDF previews
  ghostscript \
  ; \
  rm -rf /var/lib/apt/lists/*

# install the PHP extensions we need (https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions)
RUN set -ex; \
  \
  savedAptMark="$(apt-mark showmanual)"; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  libfreetype6-dev \
  libjpeg-dev \
  libmagickwand-dev \
  libpng-dev \
  libwebp-dev \
  libzip-dev \
  ; \
  \
  docker-php-ext-configure gd \
  # --with-freetype \
  #--with-jpeg \
  #--with-webp \
  ; \
  docker-php-ext-install -j "$(nproc)" \
  bcmath \
  exif \
  gd \
  mysqli \
  zip \
  ; \
  # https://pecl.php.net/package/imagick
  pecl install imagick-3.5.0; \
  docker-php-ext-enable imagick; \
  rm -r /tmp/pear; \
  \
  # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
  apt-mark auto '.*' > /dev/null; \
  apt-mark manual $savedAptMark; \
  ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
  | awk '/=>/ { print $3 }' \
  | sort -u \
  | xargs -r dpkg-query -S \
  | cut -d: -f1 \
  | sort -u \
  | xargs -rt apt-mark manual; \
  \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN set -eux; \
  docker-php-ext-enable opcache; \
  { \
  echo 'opcache.memory_consumption=1024'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=4000'; \
  echo 'opcache.revalidate_freq=2'; \
  echo 'opcache.fast_shutdown=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini
# https://wordpress.org/support/article/editing-wp-config-php/#configure-error-logging
RUN { \
  # https://www.php.net/manual/en/errorfunc.constants.php
  # https://github.com/docker-library/wordpress/issues/420#issuecomment-517839670
  echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
  echo 'display_errors = Off'; \
  echo 'display_startup_errors = Off'; \
  echo 'log_errors = On'; \
  echo 'error_log = /dev/stderr'; \
  echo 'log_errors_max_len = 1024'; \
  echo 'ignore_repeated_errors = On'; \
  echo 'ignore_repeated_source = Off'; \
  echo 'html_errors = Off'; \
  } > /usr/local/etc/php/conf.d/error-logging.ini

RUN set -eux; \
  a2enmod rewrite expires; \
  \
  # https://httpd.apache.org/docs/2.4/mod/mod_remoteip.html
  a2enmod remoteip; \
  { \
  echo 'RemoteIPHeader X-Forwarded-For'; \
  # these IP ranges are reserved for "private" use and should thus *usually* be safe inside Docker
  echo 'RemoteIPTrustedProxy 10.0.0.0/8'; \
  echo 'RemoteIPTrustedProxy 172.16.0.0/12'; \
  echo 'RemoteIPTrustedProxy 192.168.0.0/16'; \
  echo 'RemoteIPTrustedProxy 169.254.0.0/16'; \
  echo 'RemoteIPTrustedProxy 127.0.0.0/8'; \
  } > /etc/apache2/conf-available/remoteip.conf; \
  a2enconf remoteip; \
  # https://github.com/docker-library/wordpress/issues/383#issuecomment-507886512
  # (replace all instances of "%h" with "%a" in LogFormat)
  find /etc/apache2 -type f -name '*.conf' -exec sed -ri 's/([[:space:]]*LogFormat[[:space:]]+"[^"]*)%h([^"]*")/\1%a\2/g' '{}' +

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# https://br.wordpress.org/download/releases/
ARG WORDPRESS_VERSION=5.8.2
ARG WORDPRESS_SHA1=8fe743f18a2f1957eb952e23bc1c3961d131d033
RUN curl -o wordpress.tar.gz -fL "https://br.wordpress.org/wordpress-${WORDPRESS_VERSION}-pt_BR.tar.gz"; \
  echo "${WORDPRESS_SHA1} *-pt_BR.tar.gz" | sha1sum -c -; \
  \
  # upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
  tar -xzf wordpress.tar.gz -C /usr/src/; \
  rm wordpress.tar.gz; \
  \
  # https://wordpress.org/support/article/htaccess/
  [ ! -e /usr/src/wordpress/.htaccess ]; \
  { \
  echo '# BEGIN WordPress'; \
  echo ''; \
  echo 'RewriteEngine On'; \
  echo 'RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]'; \
  echo 'RewriteBase /'; \
  echo 'RewriteRule ^index\.php$ - [L]'; \
  echo 'RewriteCond %{REQUEST_FILENAME} !-f'; \
  echo 'RewriteCond %{REQUEST_FILENAME} !-d'; \
  echo 'RewriteRule . /index.php [L]'; \
  echo ''; \
  echo '# END WordPress'; \
  echo '<IfModule mod_rewrite.c>' ; \
  echo '  RewriteRule ^wp-content/plugins/helius-forms/widget/(build|public)/(.*) - [L]' ; \
  echo '  RewriteRule ^wp-content/plugins/helius-forms/widget/* totally-bogus-hbf.php [L]' ; \
  echo '</IfModule>' ; \
  } > /usr/src/wordpress/.htaccess; \
  \
  chown -R www-data:www-data /usr/src/wordpress; \
  # pre-create wp-content (and single-level children) for folks who want to bind-mount themes, etc so permissions are pre-created properly instead of root:root
  # wp-content/cache: https://github.com/docker-library/wordpress/issues/534#issuecomment-705733507
  mkdir wp-content; \
  for dir in /usr/src/wordpress/wp-content/*/ cache; do \
  dir="$(basename "${dir%/}")"; \
  mkdir "wp-content/$dir"; \
  done;

RUN rm -rf /usr/src/wordpress/wp-content/themes/twentytwenty; \
  rm -rf /usr/src/wordpress/wp-content/themes/twentynineteen; \
  rm -rf /usr/src/wordpress/wp-content/plugins/hello.php;

RUN chown -R www-data:www-data wp-content

VOLUME /var/www/html

COPY --chown=www-data:www-data wp-config-docker.php /usr/src/wordpress/
COPY --chown=www-data:www-data 000-default.conf /etc/apache2/sites-enabled/

COPY --chown=www-data:www-data docker-entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]

RUN echo "#!/bin/bash" > /docker-entrypoint.sh \
  && echo "chown -v www-data:www-data /var/www/html/wp-content/*" >> /docker-entrypoint.sh \
  && echo 'source docker-entrypoint.sh' >> /docker-entrypoint.sh \
  && chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
