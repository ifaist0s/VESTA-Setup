# VESTA-Setup&Manage
In this repository you will finf Linux shell scripts that automate the configuration and management of VESTA Control Panel on *Ubuntu 16.04*.

# THIS WORK IS NOT COMPLETE - BE EXTREMELY CAREFUL! IT MIGHT CAUSE DAMAGE!

## DNS Templates ##
In addition to the default DNS templates, I have created 3 more to add support for the great service offered at MXRoute.com. These templates reside in the DNS-Templates folder.

### Installing Templates ###
To install the templates run the following commands on your VestaCP VPS
```
curl --output /usr/local/vesta/data/templates/dns/mxroute-ghost.tpl https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ghost.tpl && chown admin:admin /usr/local/vesta/data/templates/dns/mxroute-ghost.tpl && chmod 0775 /usr/local/vesta/data/templates/dns/mxroute-ghost.tpl
curl --output /usr/local/vesta/data/templates/dns/mxroute-ocean.tpl https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ocean.tpl && chown admin:admin /usr/local/vesta/data/templates/dns/mxroute-ocean.tpl && chmod 0775 /usr/local/vesta/data/templates/dns/mxroute-ocean.tpl
curl --output /usr/local/vesta/data/templates/dns/mxroute-one.tpl https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-one.tpl && chown admin:admin /usr/local/vesta/data/templates/dns/mxroute-one.tpl && chmod 0775 /usr/local/vesta/data/templates/dns/mxroute-one.tpl
curl --output /usr/local/vesta/data/templates/dns/mxroute-friday.tpl https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-friday.tpl && chown admin:admin /usr/local/vesta/data/templates/dns/mxroute-friday.tpl && chmod 0775 /usr/local/vesta/data/templates/dns/mxroute-friday.tpl
```
or
```
su admin
cd /usr/local/vesta/data/templates/dns
curl -O https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ghost.tpl
curl -O https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-ocean.tpl
curl -O https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-one.tpl
curl -O https://raw.githubusercontent.com/ifaist0s/VESTA-Setup/master/DNS-Templates/mxroute-friday.tpl
chmod 0775 mxroute-*.tpl
```

## Provisioned space (get-prov.sh) ##
The admin of a VESTA CP Installation can define Packages, that allocate resources to users. When creating new users in VESTA GUI and assigning Packages to them, storage space is provisioned for each one. This is a draft approach in checking how much storage space is provisioned, ny counting how many users there are per different Package.

For starters, the admin needs to manually configure the Package names as variables in the script. Future versions might read the pagkages directly from VESTA.
