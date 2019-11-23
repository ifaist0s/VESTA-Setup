## Add PHP selector for PHP 7.0-7.4 to VESTA on Ubuntu

Original Topic here: https://forum.vestacp.com/viewtopic.php?f=41&t=17129

Replicating in case the above link goes dead.

### Prerequisites
```bash
apt-get update
apt install apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

# Add PPA ppa:ondrej/php 
add-apt-repository -y ppa:ondrej/php
apt-get update
a2enmod proxy_fcgi setenvif
```

### PHP 7.0

```bash
apt-get install php7.0-apcu php7.0-mbstring php7.0-bcmath php7.0-cli php7.0-curl php7.0-fpm php7.0-gd php7.0-intl php7.0-mcrypt php7.0-mysql php7.0-soap php7.0-xml php7.0-zip php7.0-memcache php7.0-memcached php7.0-zip
update-rc.d php7.0-fpm defaults
a2enconf php7.0-fpm
systemctl restart apache2
cp -r /etc/php/7.0/ /root/vst_install_backups/php7.0/
rm -f /etc/php/7.0/fpm/pool.d/*
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-70.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.stpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-70.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.tpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-70.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.sh
chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.sh
```

### PHP 7.1
```bash
apt-get install php7.1-apcu php7.1-mbstring php7.1-bcmath php7.1-cli php7.1-curl php7.1-fpm php7.1-gd php7.1-intl php7.1-mcrypt php7.1-mysql php7.1-soap php7.1-xml php7.1-zip php7.1-memcache php7.1-memcached php7.1-zip
update-rc.d php7.1-fpm defaults
a2enconf php7.1-fpm
systemctl restart apache2
cp -r /etc/php/7.1/ /root/vst_install_backups/php7.1/
rm -f /etc/php/7.1/fpm/pool.d/*
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-71.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.stpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-71.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.tpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-71.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.sh
chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.sh
```

### PHP 7.2
```bash
apt-get install php7.2-apcu php7.2-mbstring php7.2-bcmath php7.2-cli php7.2-curl php7.2-fpm php7.2-gd php7.2-intl php7.2-mysql php7.2-soap php7.2-xml php7.2-zip php7.2-memcache php7.2-memcached php7.2-zip
update-rc.d php7.2-fpm defaults
a2enconf php7.2-fpm
systemctl restart apache2
cp -r /etc/php/7.2/ /root/vst_install_backups/php7.2/
rm -f /etc/php/7.2/fpm/pool.d/*
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-72.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.stpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-72.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.tpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-72.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.sh
chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.sh
```

### PHP 7.3
```bash
apt-get install php7.3-apcu php7.3-mbstring php7.3-bcmath php7.3-cli php7.3-curl php7.3-fpm php7.3-gd php7.3-intl php7.3-mysql php7.3-soap php7.3-xml php7.3-zip php7.3-memcache php7.3-memcached php7.3-zip
update-rc.d php7.3-fpm defaults
a2enconf php7.3-fpm
systemctl restart apache2
cp -r /etc/php/7.3/ /root/vst_install_backups/php7.3/
rm -f /etc/php/7.3/fpm/pool.d/*
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-73.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.stpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-73.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.tpl
wget https://raw.githubusercontent.com/ifaist0s/VESTA-Setup-Manage/master/PHP-FPM-Templates/PHP-FPM-73.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.sh
chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.sh
```

### PHP 7.3 (soon)
