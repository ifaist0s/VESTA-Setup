# VESTA-Setup
This is a Linux shell script that automates the configuration of VESTA Control Panel on *Ubuntu 16.04*.

# THIS WORK IS NOT COMPLETE - BE EXTREMELY CAREFUL! IT MIGHT CAUSE DAMAGE!

### DNS Templates ###
In addition to the default DNS templates, I have created 3 more to add support for the great service offered at MXRoute.com. These templates reside in the DNS-Templates folder.

### Installing Templates ###
To install the templates run the following commands on your VestaCP VPS
```
curl --output /usr/local/vesta/data/templates/dns/mxroute-ghost.tpl https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ghost.tpl && chown admin:admin /usr/local/vesta/data/templates/dns/mxroute-ghost.tpl && chmod 0775 /usr/local/vesta/data/templates/dns/mxroute-ghost.tpl
curl --output /usr/local/vesta/data/templates/dns/mxroute-ocean.tpl https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ocean.tpl && chown admin:admin /usr/local/vesta/data/templates/dns/mxroute-ocean.tpl && chmod 0775 /usr/local/vesta/data/templates/dns/mxroute-ocean.tpl
curl --output /usr/local/vesta/data/templates/dns/mxroute-one.tpl https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-one.tpl && chown admin:admin /usr/local/vesta/data/templates/dns/mxroute-one.tpl && chmod 0775 /usr/local/vesta/data/templates/dns/mxroute-one.tpl
```
or
```
su admin
cd /usr/local/vesta/data/templates/dns
curl -O https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ghost.tpl
curl -O https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ocean.tpl
curl -O https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-one.tpl
chmod 0775 mxroute-*.tpl
```
