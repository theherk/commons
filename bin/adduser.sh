#!/bin/bash

USR=$1
KEY=$2
GRPS=$3
mkdir -p /home/${USR}
useradd -d /home/${USR} -s /bin/bash ${USR}
usermod -G ${GRPS} ${USR}
passwd -d ${USR}
chown ${USR}:${USR} /home/${USR}
mkdir -p /home/${USR}/.ssh
chmod 0700 /home/${USR}/.ssh
chown ${USR}:${USR} /home/${USR}/.ssh
touch /home/${USR}/.ssh/authorized_keys
chmod 0600 /home/${USR}/.ssh/authorized_keys
chown ${USR}:${USR} /home/${USR}/.ssh/authorized_keys
echo "${KEY}" >> /home/${USR}/.ssh/authorized_keys
