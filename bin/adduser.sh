#!/bin/bash

USR=$1
KEY=$2
GRPS=$3
useradd ${USR}
usermod -G ${GRPS} ${USR}
passwd -d ${USR}
mkdir /home/${USR}/.ssh
chmod 0700 /home/${USR}/.ssh
chown ${USR}:${USR} /home/${USR}/.ssh
touch /home/${USR}/.ssh/authorized_keys
chmod 0600 /home/${USR}/.ssh/authorized_keys
chown ${USR}:${USR} /home/${USR}/.ssh/authorized_keys
echo "${KEY}" >> /home/${USR}/.ssh/authorized_keys
