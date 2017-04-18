#!/bin/bash

CONSUL_SKIP_CURL=${CONSUL_SKIP_CURL:-false}
CONSUL_BOOTSTRAP_SOLO=${CONSUL_BOOTSTRAP_SOLO:-false}

if [[ -n "${CONSUL_CLUSTER_IPS}" ]];then
    START_JOIN=""
    for IP in $(echo ${CONSUL_CLUSTER_IPS} | sed -e 's/,/ /g');do
        if [ "X${CONSUL_SKIP_CURL}" == "Xtrue" ];then
            START_JOIN+=" ${IP}"
        elif [ $(curl --connect-timeout 2 -sI ${IP}:8500/ui/|grep -c "HTTP/1.1 200 OK") -eq 1 ];then
            START_JOIN+=" ${IP}"
        fi
    done
    START_JOIN=$(echo ${START_JOIN}|sed -e 's/ /\",\"/g')
    if [ "X${START_JOIN}" == "X" ] && [ "X${CONSUL_BOOTSTRAP_SOLO}" != "Xtrue" ];then
        echo "Could not find any CLUSTER IP '${CONSUL_CLUSTER_IPS}' and CONSUL_BOOTSTRAP_SOLO!=true"
        exit 1
    elif [ "X${START_JOIN}" == "X" ] && [ "X${CONSUL_BOOTSTRAP_SOLO}" == "Xtrue" ];then
        BOOTSTRAP_CONSUL=true
    else
        sed -i -e "s#\"start_join\":.*#\"start_join\": [\"${START_JOIN}\"],#" /etc/consul.d/agent.json
    fi
fi
