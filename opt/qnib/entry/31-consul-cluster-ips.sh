#!/bin/bash

set -x
if [[ -n "${CONSUL_CLUSTER_IPS}" ]];then
    START_JOIN=""
    for IP in $(echo ${CONSUL_CLUSTER_IPS} | sed -e 's/,/ /g');do
        if [[ "X${CONSUL_SKIP_CURL}" == "Xtrue" ]];then
            START_JOIN+=" ${IP}"
        elif [ $(curl --connect-timeout 2 -sI ${IP}:8500/ui/|grep -c "HTTP/1.1 200 OK") -eq 1 ];then
            START_JOIN+=" ${IP}"
        fi
    done
    START_JOIN=$(echo ${START_JOIN}| sed -e 's/^ //' -e 's/ /\",\"/g')
    if [[ "X${START_JOIN}" != "X" ]] && [[ "X${SWARM_TASK_SLOT}" != "X1" ]];then
      echo " >> Adding start_join: '${START_JOIN}'"
      sed -i -e "s#\"start_join\":.*#\"start_join\": [\"${START_JOIN}\"],#" /etc/consul.d/agent.json
    fi
fi
