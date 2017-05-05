# playwithdocker-swarm-generator
Shell script which generates a docker swarm in the Docker Playground.

This script generates a Docker Swarm running in the Docker Playground. To initialize your playground goto play-with-docker.com and verify you're not a robot.

# Prerequisites
This scripts depends on docker-machine and the corresponding PWD driver.
* https://docs.docker.com/machine/overview
* https://github.com/franela/docker-machine-driver-pwd

# Steps

* Get a copy of the playwithdocker-swarm-generator.sh script.
* Initialize your playground. Goto http://play-with-docker.com and finish the captcha.
* Copy the url to use with docker-machine.
* Run the script and make sure you enter the mandatory arguments:
** Play With Docker URL
** Amount of managers
** Amount of workers

```
$ ./playwithdocker-swarm-generator.sh http://host2.labs.play-with-docker.com/p/c28276a3-0ff0-4484-b1de-ffb8ce741577 1 1

[INFO] 1 manager(s) requested
[INFO] Creating manager1...
Running pre-create checks...
Creating machine...
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env manager1


[INFO] 1 worker(s) requested
[INFO] Creating worker1...
Running pre-create checks...
Creating machine...
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env worker1


[INFO] Initializing docker swarm...
Swarm initialized: current node (w3jtf8u127gkzfcnixt1v9cas) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-5xhzihifa0ykex5zgec9r743nwi431yczw6irnahuqomqzwacd-1dhai3exfyvngg0r20923uuhj \
    10.0.52.3:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[INFO] MANAGER_TOKEN is SWMTKN-1-5xhzihifa0ykex5zgec9r743nwi431yczw6irnahuqomqzwacd-59013a1xwynuhrqq823odb4m4
[INFO] MANAGER_IP_PORT is 10.0.52.3:2377
[INFO] WORKER_TOKEN is SWMTKN-1-5xhzihifa0ykex5zgec9r743nwi431yczw6irnahuqomqzwacd-1dhai3exfyvngg0r20923uuhj
[INFO] WORKER_IP_PORT is 10.0.52.3:2377


[INFO] Node worker1 is joining the swarm...
This node joined a swarm as a worker.


[INFO] Creating visualizer container...
s8nqlfrqmy08m0572n1k271s5
```

After a small amount of time the Docker Swarm Cluster is up and running. In the webpage there will popup a link to 8080, containing a visualizer web interface (https://github.com/dockersamples/docker-swarm-visualizer).

# Remove all docker nodes at once in the current playground
```
$ docker-machine ls | grep " pwd " | awk '{print $1}' | xargs docker-machine rm -f
```

# Deploy nginx service with 5 replicas
Now we can deploy nginx with 5 replicas and bind them to the workers. Make sure you switch to a manager before creating the service.

```
$ eval $(docker-machine env manager1)
$ docker service create \
    --name nginx \
    --replicas 5 \
    --publish 8081:80 \
    --constraint node.role==worker \
    nginx
```
