#!/bin/bash

APIKEY="keepitsecret-keepitsafe"
ZONE="domain.com"
RECORD="mylaptop.domain.com"

IPADDR=`dig +short myip.opendns.com @resolver1.opendns.com`

#copied from http://www.linuxjournal.com/content/validating-ip-address-bash-script
function valid_ip()
{
  local ip=$1
  local stat=1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
  then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
      stat=$?
  fi
  return $stat
}

valid_ip $IPADDR
if [ $? -ne 0 ]
then
  echo "Couldn't find a valid IP address, your interface might be down or you failed to fill out the 4 obvious lines at the top"
  exit
fi

curl -s -X POST -H "X-NSONE-Key: $APIKEY" -d '{
  "answers": [
   {
    "answer": [
     "'$IPADDR'"
    ]
   }
  ]
}' https://api.nsone.net/v1/zones/$ZONE/$RECORD/A
