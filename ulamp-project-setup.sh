#!/bin/bash

if [ -z "$1" ]; then echo "Project name is not given"; exit 1; fi
if [ -z "$2" ]; then echo "Project location is not given"; exit 1; fi
if [ -z "$3" ]; then echo "Server alias is not given"; exit 1; fi

if [ ! -d "/etc/apache2/sites-available" ]; then echo "Can't find '/etc/apache2/sites-available' to create vhost file"; exit 1; fi
if [ ! -e "/etc/hosts" ]; then echo "Can't find '/etc/hosts' to create an entry in host file"; exit 1; fi
if [ -d "$2$1" ]; then echo "Project folder already exists '$2$1'"; exit 1; fi
if [ -e "/etc/apache2/sites-available/$1" ]; then echo "vhost file already exists '/etc/apache2/sites-available/$1'"; exit 1; fi

echo -e "Setting up php project '$1' in folder '$2' with server alias '$3' \n"

echo -e "Creating project folder '$2$1' \n"
mkdir "$2$1"
echo "<h1>Congrats!</h1><?php phpinfo();" >> "$2$1/index.php"

echo -e "Creating vhost file\n"
echo -e "<VirtualHost *:80>
 DocumentRoot $2$1
 ServerName $3
 <Directory $2$1>
   Order Deny,Allow
   Allow from All
 </Directory>
 ErrorLog "/var/log/apache2/$1-error.log"
 CustomLog "/var/log/apache2/$1-access.log" common
</VirtualHost>" >> "/etc/apache2/sites-available/$1"
 
ln -s "/etc/apache2/sites-available/$1" "/etc/apache2/sites-enabled/$1"

echo -e "Update vhosts file\n"

echo "127.0.0.1 $3" >> "/etc/hosts"

echo -e "Restarting apache server\n"

service apache2 restart

echo -e "You can access the site at http://$3\n"
