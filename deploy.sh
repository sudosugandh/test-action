#!/bin/bash

# Function to run SSH commands securely with password authentication
run_ssh_with_password() {
    local host="$1"
    local username="$2"
    local password="$3"
    local port="$4"
    local script="$5"
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p "$port" "$username@$host" "$script"
}

# Enable Maintenance Mode on Server 1
run_ssh_with_password "$SERVER1_HOST" "$SERVER1_USERNAME" "$SERVER1_PASSWORD" 22 "cd /var/www/html/test-action && php artisan down"

# Deploy Code on Server 2
run_ssh_with_password "$SERVER2_HOST" "$SERVER2_USERNAME" "$SERVER2_PASSWORD" 22 "cd /var/www/html/test-action && sh deploy.sh"

# Disable Maintenance Mode on Server 1
run_ssh_with_password "$SERVER1_HOST" "$SERVER1_USERNAME" "$SERVER1_PASSWORD" 22 "cd /var/www/html/test-action && php artisan up"
