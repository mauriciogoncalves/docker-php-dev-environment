#!/bin/sh
/usr/sbin/sshd -D -o ListenAddress=0.0.0.0 &
source /etc/apache2/envvars
/usr/sbin/apache2 -DFOREGROUND
