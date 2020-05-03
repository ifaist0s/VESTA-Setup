# Vesta / Hestia Setup & Manage
This is a collection of Linux shell scripts that automate the setup, configuration and management of Vesta / Hestia Control Panels. 

Most of the scripts have been created and tested on *Ubuntu 16.04* and *Ubuntu 18.04*. Some will work only in Vesta (the older ones) while some othere will work in both Vesta/Hestia.

# BE EXTREMELY CAREFUL! THIS WORK IS NOT COMPLETE - IT MIGHT CAUSE DAMAGE!

## DNS Templates ##
In addition to the default DNS templates, I have created some more to add support for the great service offered at MXRoute.com. These templates reside in the Templates/DNS folder.

### Installing Templates ###
To install the templates, you need to download them in your Vesta/Hestia templates folder:
* /usr/local/vesta/data/templates/dns
* /usr/local/hestia/data/templates/dns
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
## PHP-FPM-Templates ##
Vesta does not support (yet) different php versions per domain. A user has posted a [guide](https://forum.vestacp.com/viewtopic.php?f=41&t=17129) on how to install the required support for that. The files which are contained in this folder are the required template and bash files.

Hestia can be installed with MultiPHP support, so there is no need to use these templetes.

## Provisioned space (get-alloc-stor.sh) ##
The admin of a Vesta/Hestia CP Installation can define Packages, that allocate resources to users. When creating new users in Vesta/Hestia GUI and assigning Packages to them, storage space is allocated to each one. This is a draft approach in checking how much storage space is allocated, by counting how many users are assigned to each Package.
