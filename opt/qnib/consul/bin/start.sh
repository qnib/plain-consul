#!/bin/bash

JOIN_WAN=""
if [ "X${WAN_SERVER}" != "X" ];then
    JOIN_WAN="-join-wan=${WAN_SERVER}"
fi

trap 'consul leave' SIGTERM

consul agent -config-file=/etc/consul.d/agent.json -config-dir=/etc/consul.d ${JOIN_WAN}
