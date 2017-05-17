***Assignment 4***

The main aim of the assignment is to create a system that probes the sysUpTime for devices, up to 150 for every 30seconds. 
Results are displayed on a web dashboard in such a way that, if a device has failed to respond to the last message the device should be presented using a light red color, and for each request the device misses, the colour should be made more red. After 30 lost requests, the stastus of the device will be displayed with dark red color.

***Software requirements and Basic Installations***

mysql-server
apache2
snmpd
snmp
php5

***Install packages from terminal*** (sudo apt-get install ____)

libdbi-perl
libpango1.0-dev 
libxml2-dev
libsnmp-perl 
libsnmp-dev 
libnet-snmp-perl
perl -MCPAN -e 'install Net::SNMP'
	
***Steps to run Assignment 4***

*Go to the  terminal and go to the working directory i.e. /var/www/html.
*Run the script in terminal using command "perl backend.pl" 
*Wait for a while for the values of the system uptime and lost request to be updated .
*open browser to see the number of lost request with color notation and the device info can be retrieved by clicking on the id, the color intensity determines the ammount of lost request.

***Note***
The permission to the directory et2536-sapo15 should be enabled.
