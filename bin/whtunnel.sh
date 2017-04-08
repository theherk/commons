#!/bin/bash
set +e
SSH_OPTIONS=" -i /home/h4s/.ssh/whtunnel2"
export AUTOSSH_GATETIME=0
export AUTOSSH_PORT=39122
#autossh -vv -- $SSH_OPTIONS -o 'ControlPath none' -R 31111:localhost:39122 h4s@24.130.180.42 -p 39999 -N > ~/whtunnel.log 2> ~/whtunnel_error.log &
autossh -vv -- $SSH_OPTIONS -o 'ControlPath none' -R 39111:localhost:39122 h4s@24.130.180.42 -p 39999 -N

# connect from home using: ssh localhost -p 39111 with proper identity
# ensure sshd running on both ends
# tunnel web traffic with: sshuttle -r h4s@localhost:39111 0.0.0.0/
0
