#!/bin/bash

## Set the PWD_URL variable as seen at "http://labs.play-with-docker.com" after confirming you're not a robot.
export PWD_URL="$1"
export MANAGER_AMOUNT="$2"
export WORKER_AMOUNT="$3"
TOTAL_AMOUNT=$((MANAGER_AMOUNT+WORKER_AMOUNT))

## Create docker manager nodes
echo ""
echo "[INFO] $MANAGER_AMOUNT manager(s) requested"
m=1
while [[ $m -le $MANAGER_AMOUNT ]]
do
	echo "[INFO] Creating manager$m..."
	docker-machine create -d pwd "manager${m}"
	m=$[$m+1]
done
echo ""

## Create docker worker nodes
echo ""
echo "[INFO] $WORKER_AMOUNT worker(s) requested"
w=1
while [[ $w -le $WORKER_AMOUNT ]]
do
	echo "[INFO] Creating worker$w..."
	docker-machine create -d pwd "worker${w}"
	w=$[$w+1]
done
echo ""

## Initialize the docker swarm at the first manager node
echo ""
MANAGER="manager1"
echo "[INFO] Initializing docker swarm..."
eval $(docker-machine env $MANAGER)
docker swarm init --advertise-addr eth0
MANAGER_TOKEN=$(docker swarm join-token manager | grep token | sed 's/^.*token //' | sed 's/ \\//')
echo "[INFO] MANAGER_TOKEN is $MANAGER_TOKEN"
MANAGER_IP_PORT=$(docker swarm join-token manager | grep token -A1 | grep -v token | sed 's/^.* //')
echo "[INFO] MANAGER_IP_PORT is $MANAGER_IP_PORT"
WORKER_TOKEN=$(docker swarm join-token worker | grep token | sed 's/^.*token //' | sed 's/ \\//')
echo "[INFO] WORKER_TOKEN is $WORKER_TOKEN"
WORKER_IP_PORT=$(docker swarm join-token worker | grep token -A1 | grep -v token | sed 's/^.* //')
echo "[INFO] WORKER_IP_PORT is $WORKER_IP_PORT"
echo ""

function swarm_join_manager() {
	eval $(docker-machine env $1)
	docker swarm join --token $MANAGER_TOKEN $MANAGER_IP_PORT
}

function swarm_join_worker() {
	eval $(docker-machine env $1)
	docker swarm join --token $WORKER_TOKEN $WORKER_IP_PORT
}

## Add manager(s) to the swarm cluster
m=2
while [ $m -le $MANAGER_AMOUNT ]
do
	echo "[INFO] Node manager$m is joining the swarm..."
	swarm_join_manager "manager${m}"
	m=$[$m+1]
done
echo ""

## Add worker(s) to the swarm cluster
w=1
while [ $w -le $WORKER_AMOUNT ]
do
	echo "[INFO] Node worker$w is joining the swarm..."
	swarm_join_worker "worker${w}"
	w=$[$w+1]
done
echo ""

## Start visualizer container
echo ""
echo "[INFO] Creating visualizer container..."
eval $(docker-machine env $MANAGER)
docker service create \
    --name=viz \
    --publish=8080:8080/tcp \
    --constraint=node.role==manager \
    --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    dockersamples/visualizer
echo ""

