# LAMP (without MySQL): Apache + PHP
FROM php:8.2-apache

# Install system deps + common PHP extensions (including mysql client libs)
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install \
      pdo \
      pdo_mysql \
      mysqli \
      zip \
    && a2enmod rewrite headers \
    && rm -rf /var/lib/apt/lists/*

# Optional: set Apache document root to /var/www/html/public (common for frameworks)
# If you don't need this, comment these lines out.
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf && \
    sed -ri "s!/var/www/!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy your application code
# (Assumes your app is in the same directory as this Dockerfile)
COPY var/www/html /var/www/html

# Permissions (adjust user/group if needed)
RUN chown -R www-data:www-data /var/www/html

# --- Runtime env -> app config (optional but useful) ---
# We'll generate /var/www/html/.env.runtime.php from env vars on container start.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
