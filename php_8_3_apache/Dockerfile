# Use a imagem PHP 8.3 com Apache
FROM php:8.3-apache

# Atualizar pacotes e instalar dependências
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    libpng-dev \
    libgd-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libwebp-dev \
    libmagickwand-dev \
    autoconf \
    build-essential \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd intl pdo_mysql zip mysqli \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar o Git para evitar problemas de permissão
RUN git config --global --add safe.directory /var/www/html

# Copiar e configurar o docker-entrypoint.sh
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Habilitar mod_rewrite do Apache
RUN a2enmod rewrite

# Configurar o Apache para usar o diretório /var/www/html como DocumentRoot
RUN sed -i 's|/var/www/html|/var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Copiar o php.ini personalizado
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Configurar diretório de trabalho
WORKDIR /var/www/html

# Definir o ponto de entrada padrão
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Comando padrão para iniciar o Apache
CMD ["apache2-foreground"]
