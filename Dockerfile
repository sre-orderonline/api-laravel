FROM php:8.0.19
RUN apt-get update -y && apt-get install -y \
    openssl zip unzip git \
    libcurl4-openssl-dev pkg-config libssl-dev\
    libpq-dev libonig-dev
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo mbstring pdo_pgsql
WORKDIR /app
COPY . /app

RUN composer install

CMD php artisan serve --host=0.0.0.0 --port=8181
EXPOSE 8181
