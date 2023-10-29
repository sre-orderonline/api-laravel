# Stage 1: Build the application
FROM composer:2.0 as builder

WORKDIR /app

# Install PHP extensions required by Laravel
RUN docker-php-ext-install pdo pdo_pgsql

# Copy composer files and install dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev

# Copy the rest of the application code
COPY . .

# Generate the optimized autoloader and clear the cache
RUN composer dump-autoload
RUN php artisan config:cache
RUN php artisan route:cache

# Stage 2: Create a lightweight image for production
FROM php:8.0-fpm

WORKDIR /app

# Install PHP extensions required by Laravel
RUN docker-php-ext-install pdo pdo_pgsql

# Install additional dependencies (adjust as needed)
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip unzip

# Install Composer globally
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

# Copy the application from the previous stage
COPY --from=builder /app /app

# Set the environment variables
# ENV APP_ENV=production
# ENV APP_KEY=your-app-key
# ENV DB_CONNECTION=pgsql
# ENV DB_HOST=your-postgresql-host
# ENV DB_PORT=5432
# ENV DB_DATABASE=your-database-name
# ENV DB_USERNAME=your-database-username
# ENV DB_PASSWORD=your-database-password

# Expose the port if you're using a web server like Nginx
# EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]

# You may need to configure a web server (e.g., Nginx or Apache) to serve your Laravel application in a production environment. The specific setup can vary based on your requirements.
