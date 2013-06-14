#!/bin/bash
if [ -f /etc/resolv.conf.hold ]; then # Put back the orginal resolv.conf
        mv /etc/resolv.conf.hold /etc/resolv.conf
fi 
