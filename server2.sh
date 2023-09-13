#!/bin/bash

# Navigate to the project directory on Server 2
cd /var/www/html/test-action

# Pull the latest changes from your repository
git pull origin main

# Install/update dependencies using Composer
composer install --no-interaction --no-dev --optimize-autoloader

# Run database migrations
php artisan migrate --force

# Clear the application cache
php artisan config:cache
php artisan route:cache
php artisan view:cache
