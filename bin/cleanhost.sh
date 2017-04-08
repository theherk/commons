#!/bin/bash

if [ -z "$1" ]
then
    echo "No argument"
else
    cp ~/.ssh/known_hosts ~/.ssh/known_hosts.safe
    awk "!/$1/" ~/.ssh/known_hosts > tmp && mv tmp ~/.ssh/known_hosts
fi
