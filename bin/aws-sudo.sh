#!/usr/bin/env bash

ROLE_TO_ASSUME=$1

if [ "$ROLE_TO_ASSUME" == "clear" ]
then
	echo "unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN"
	exit
fi

TMP=$(mktemp ar-XXXXXXXX)
aws sts assume-role --role-arn $ROLE_TO_ASSUME --role-session-name="aws_sudo"  --output=json > $TMP

echo export \
     AWS_ACCESS_KEY_ID=$(jq '.Credentials.AccessKeyId' $TMP | xargs echo) \
     AWS_SECRET_ACCESS_KEY=$(jq '.Credentials.SecretAccessKey' $TMP | xargs echo) \
     AWS_SECURITY_TOKEN=$(jq '.Credentials.SessionToken' $TMP | xargs echo) \
     AWS_SESSION_TOKEN=$(jq '.Credentials.SessionToken' $TMP | xargs echo)

rm $TMP
