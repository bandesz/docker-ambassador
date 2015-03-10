#!/bin/bash

if [ -z $ENABLE_SSL ] then
  env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/exec socat -ls TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3 /' | sh
else
  echo "$CLIENT_PRIVATE_KEY" > /etc/client.pem
  echo "$SERVER_PUBLIC_KEY" > /etc/server.crt
  chmod 600 /etc/client.pem /etc/server.crt
  if [ -z $ROLE == 'server' ] then
  	env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/exec socat OPENSSL-LISTEN:\1,fork,reuseaddr,cert=\/etc\/server.pem,cafile=\/etc\/client.crt TCP4:\2:\3 /' | sh
  else
    env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/exec socat TCP-LISTEN:\1,reuseaddr,fork OPENSSL:\2:\3,cert=\/etc\/client.pem,cafile=\/etc\/server.crt /' | sh
  fi
fi  