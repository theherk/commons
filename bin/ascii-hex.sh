#!/usr/bin/env sh

if [ "${#1}" -eq "1" ]; then
	out=$(printf "%02x" "'$1")
else
	out=$(printf "\x$1")
fi
echo "$out"
