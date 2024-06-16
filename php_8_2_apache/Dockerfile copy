# Use a imagem PHP 8.2 com Apache
FROM php:8.2-apache

# Atualizar pacotes e instalar dependências
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    libpng-dev \
    libgd-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalação do Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Instalar extensões PHP necessárias
RUN docker-php-ext-install intl pdo_mysql zip gd mysqli

# Instalação do Redis
RUN pecl install redis && docker-php-ext-enable redis

# Configurar o Git
RUN git config --global --add safe.directory /var/www/html

# Copiar o arquivo docker-entrypoint.sh para o contêiner
COPY docker-entrypoint.sh /usr/local/bin/

# Dar permissão de execução ao script
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Definir o ponto de entrada padrão como o script docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Habilitar mod_rewrite do Apache
RUN a2enmod rewrite

# Configurar o Apache para usar o diretório /var/www/html como DocumentRoot
RUN sed -i 's|/var/www/html|/var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Criar e copiar o php.ini personalizado
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Definir diretório de trabalho
WORKDIR /var/www/html

# Comando padrão para iniciar o Apache
CMD ["apache2-foreground"]