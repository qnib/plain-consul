#!/bin/bash
CONSUL_BOOTSTRAP_EXPECT=${CONSUL_BOOTSTRAP_EXPECT:-1}

CONSUL_MEMBERS_CNT=$(consul members |grep -c server)
if [[ "X${SWARM_TASK_SLOT}" == "X1" ]] && [[ ${CONSUL_MEMBERS_CNT} -eq 1 ]] && [[ ${CONSUL_BOOTSTRAP_EXPECT} -ne 1 ]];then
  echo "My slot is 1 and I expect ${CONSUL_BOOTSTRAP_EXPECT} servers while only seeing ${CONSUL_MEMBERS_CNT} - I must initialize"
  exit 0
elif [[ ${CONSUL_MEMBERS_CNT} -eq 1 ]] && [[ ${CONSUL_BOOTSTRAP_EXPECT} -ne 1 ]];then
  echo "Task.Slot:${SWARM_TASK_SLOT}!=1 | expect ${CONSUL_BOOTSTRAP_EXPECT} servers | only seeing ${CONSUL_MEMBERS_CNT} - FAIL"
  exit 1
elif "X${SWARM_TASK_SLOT}" != "X" ]];then
  echo "Task.Slot:${SWARM_TASK_SLOT} | ${CONSUL_MEMBERS_CNT} server present - OK"
fi
