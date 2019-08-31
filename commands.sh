cd ~

sudo apt-get update

sudo apt-get install nodejs

sudo apt-get install npm

sudo apt-get install build-essential

# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04

sudo npm install -g pm2

sudo apt install -y mongodb

# check status for mongodb `sudo systemctl status mongodb`

sudo apt install nginx

# Check installed app

sudo ufw app list

# since we havn't added any ssl we will open HTTP

sudo ufw allow 'Nginx HTTP'

cd ..

cd var/www/

git clone repo/api

git clone repo/client

# For API

cd api

# Install dependancies 

npm install

# Run the app

npm src/index.js

# Then make use of pm2

pm2 start src/index.js

pm2 startup systemd

# Copy path shown and start the app

# Create a proxy and reverse proxy

sudo vim /etc/nginx/sites-available/default

# Change setting in location e.g 
# This stuff can also be done seperately user 
# server connection especialluy where it requires 
location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

# Set up location for React app
location /reactapp {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

# Make directory in sites available for both your React and Node app
cd /etc/nginx/sites-available
mkdir api.domain.com && domain.com 

sudo vim /etc/nginx/sites-available/api.domain.com # Nodejs App
sudo vim /etc/nginx/sites-available/domain.com # React app

# For the React edit the script as follows
server {
    # Serve the build version of React
    root /var/www/reactapp/build
    server_name domain.com
    index index.html index.htm 
    location / {
        try_files $uri /index.html
    }
}

# Remove the default settings
rm sites-enabled/default

# link sites(enabled) to sites available 
ln -s /etc/nginx/sites-enabled/api.domain.com /etc/nginx/sites-enabled
ln -s /etc/nginx/sites-enabled/domain.com /etc/nginx/sites-enabled

# G0 ahead and test nginx
sudo nginx -t

# Check logs for nginx
cd /var/log/nginx/

# Give permission for nginx for the build version of React application
sudo chown -R www-data:www-data /var/www/domain.com/build

# Restart nginx
sudo systemctl restart nginx
    
# Do stuff of running app using pm2

cd ..
cd /var/www/reactapp
npm install

pm2 start npm -- start

# Now checking on mongodb, set up .env in digital ocean

printenv # check on available env files

touch .env

vim .env

# Add the following in .env file created
DATABASE_URL="mongodb://localhost:27017/mydb"

# Start the app

