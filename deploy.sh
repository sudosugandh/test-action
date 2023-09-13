#!/bin/bash

# Function to run SSH commands securely
run_ssh() {
    local host="$1"
    local username="$2"
    local key="$3"
    local port="$4"
    local script="$5"
    SSH_AUTH_SOCK=/dev/null ssh -i "$key" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p "$port" "$username@$host" "$script"
}

# Enable Maintenance Mode on Server 1
run_ssh "${{ secrets.SERVER1_HOST }}" "${{ secrets.SERVER1_USERNAME }}" "/home/ubuntu/.ssh/Testingserver.pem" 22 "cd /var/www/html/test-action && php artisan down"

# Deploy Code on Server 2
run_ssh "${{ secrets.SERVER2_HOST }}" "${{ secrets.SERVER2_USERNAME }}" "/home/ubuntu/.ssh/Testingserver.pem" 22 \
    "cd /path/to/server2 && git pull origin main && composer install --no-interaction --no-dev --optimize-autoloader && php artisan migrate --force && php artisan config:cache && php artisan route:cache && php artisan view:cache"

# Disable Maintenance Mode on Server 1
run_ssh "${{ secrets.SERVER1_HOST }}" "${{ secrets.SERVER1_USERNAME }}" "/home/ubuntu/.ssh/Testingserver.pem" 22 "cd /var/www/html/test-action && php artisan up"

# Run Deploy Script on Server 2
run_ssh "${{ secrets.SERVER2_HOST }}" "${{ secrets.SERVER2_USERNAME }}" "/home/ubuntu/.ssh/Testingserver.pem" 22 "cd /var/www/html/test-action && sh deploy.sh"
