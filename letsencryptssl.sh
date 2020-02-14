# First make sure that in Digital Ocean you add
# An A record with www.domain.com pointing to your server’s public IP address.

# install certbot 
sudo add-apt-repository ppa:certbot/certbot

# install certbot nginx package
sudo apt install python-certbot-nginx

# Configure nginx 
sudo vim /etc/nginx/sites-available/domain.com

# then modify the server part 
server_name domain.com www.domain.com;

# Then
sudo nginx -t

# reload nginx
sudo systemctl reload nginx

# allow https through the firewall
sudo ufw status

sudo ufw allow 'Nginx Full'

sudo ufw delete allow 'Nginx HTTP'

sudo ufw status

# obtaining ssl certificate
sudo certbot --nginx -d domain.com -d www.domain.com

# verify certbot auto renewal
sudo certbot renew --dry-run

# how file will look like after installation of certbot
server {
        root /var/www/voguish-ui/build;
        index index.html index.htm;
        server_name domain.com www.domain.com;
        location / {
                try_files $uri /index.html;
        }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/domain.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/domain.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.domain.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = domain.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    server_name domain.com www.domain.com;
    listen 80;
    return 404; # managed by Certbot
}
