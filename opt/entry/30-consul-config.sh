#!/bin/bash
set -x

NODE_NAME=${CONSUL_NODE_NAME}
CONSUL_SERVER=${CONSUL_SERVER:-false}
ADDV_ADDR=${CONSUL_ADDV_ADDR}
CONSUL_BOOTSTRAP=${CONSUL_BOOTSTRAP:-false}
IP_ADDR=$(go-fisherman --print-container-ip)

if [ "X${CONSUL_BOOTSTRAP}" == "Xtrue" ];then
    sed -i -e "s#\"bootstrap\":.*#\"bootstrap\": true,#" /etc/consul.d/agent.json
    CONSUL_SERVER=true
elif [ "X${CONSUL_BOOTSTRAP_EXPECT}" != "X" ];then
    sed -i -e "s#\"bootstrap\":.*#\"bootstrap_expect\": ${CONSUL_BOOTSTRAP_EXPECT},#" /etc/consul.d/agent.json
    CONSUL_SERVER=true
fi
if [ "X${CONSUL_SERVER}" == "Xtrue" ];then
    sed -i -e "s#\"server\":.*#\"server\": true,#" /etc/consul.d/agent.json
fi
if [ "X${DNS_RECURSOR}" != "X" ];then
    sed -i -e "s#\"recursor\":.*#\"recursor\": \"${DNS_RECURSOR}\",#" /etc/consul.d/agent.json
fi
if [ "X${ADDV_ADDR}" != "X" ];then
    sed -i -e "s#\"advertise_addr\":.*#\"advertise_addr\": \"${ADDV_ADDR}\",#" /etc/consul.d/agent.json
else
    sed -i -e "s#\"advertise_addr\":.*#\"advertise_addr\": \"${IP_ADDR}\",#" /etc/consul.d/agent.json
fi

if [[ -z ${NODE_NAME} ]];then
    NODE_NAME=$(hostname -f)
fi
sed -i -e "s#\"node_name\":.*#\"node_name\": \"${NODE_NAME}\",#" /etc/consul.d/agent.json
