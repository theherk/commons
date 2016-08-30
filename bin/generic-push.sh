#!/usr/bin/env bash

URL_DEFAULT="https://cleardata.artifactoryonline.com/cleardata/"

read -e -p "artifactory url: " -i "$URL_DEFAULT" URL
read -e -p "repo: " REPO
read -e -p "file: " FILE
read -e -p "target path: " TARGET_PATH
read -e -p "username: " USER
read -e -s -p "password: " PASS

curl -k -u"$USER":"$PASS" -T $FILE "${URL}${REPO}/${TARGET_PATH}"
