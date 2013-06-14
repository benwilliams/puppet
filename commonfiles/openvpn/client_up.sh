#!/bin/bash
mv /etc/resolv.conf /etc/resolv.conf.hold # back up old file
for OPTION in ${!foreign_option_*}
do
       	if [ -z "${!OPTION}" ]; then
               	break
        fi
       	if [ -n "$(echo ${!OPTION} | grep DOMAIN)" ] || [ -n "$(echo ${!OPTION} | grep DNS)" ]; then
               	echo ${!OPTION} |sed -e 's/dhcp-option DOMAIN/search/g'	-e 's/dhcp-option DNS/nameserver/g' >> /etc/resolv.conf
        fi
done
if [ ! -f /etc/resolv.conf ]; then # openvpn did not set any DNS information
        mv /etc/resolv.conf.hold /etc/resolv.conf
fi 
