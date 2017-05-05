# playwithdocker-swarm-generator
Shell script which generates a docker swarm in the Docker Playground

This script generates a Docker Swarm running in the Docker Playground. To initialize your playgroudn goto play-with-docker.com and verify you're not a robot.

# Prerequisites
This scripts depends on docker-machine and the corresponding PWD driver.
* https://docs.docker.com/machine/overview
* https://github.com/franela/docker-machine-driver-pwd

# Steps

* Get a copy of the playwithdocker-swarm-generator.sh script.
* Initialize your playground. Goto http://play-with-docker.com and finish the captcha.
* Copy the url to use with docker-machine.
* Run the script and make sure to enter the needed arguments, PWD_URL MANAGER_COUNT and WORKER_COUNTER.
```
$ ./playwithdocker-swarm-generator.sh http://host1.labs.play-with-docker.com/p/deacacea-e02a-4b0d-9d09-721110340e9c 3 3

[INFO] 3 manager(s) requested
[INFO] Creating manager1...
Running pre-create checks...
Creating machine...
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env manager1
[INFO] Creating manager2...
Running pre-create checks...
Creating machine...
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env manager2
[INFO] Creating manager3...
Running pre-create checks...
Creating machine...
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env manager3


[INFO] 3 worker(s) requested
[INFO] Creating worker1...
Running pre-create checks...
Creating machine...
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env worker1
[INFO] Creating worker2...
Running pre-create checks...
Creating machine...
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env worker2
[INFO] Creating worker3...
Running pre-create checks...
Creating machine...
Error creating machine: Error in driver during machine creation: Could not create instance <nil> &{409 Conflict 409 HTTP/1.1 1 1 map[Date:[Fri, 05 May 2017 20:22:12 GMT] Content-Length:[0] Content-Type:[text/plain; charset=utf-8]] {} 0 [] false false map[] 0xc42015e200 <nil>}


[INFO] Initializing docker swarm...
Swarm initialized: current node (5inys15s45i786kyg8jy0m6wr) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-4h8kibrmh79onbrwxj0l3y32sh9e8cwn25gschygpvfdgytjle-9runol5jrvwqf7fdozk5c0gng \
    10.0.31.3:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[INFO] MANAGER_TOKEN is SWMTKN-1-4h8kibrmh79onbrwxj0l3y32sh9e8cwn25gschygpvfdgytjle-00tkdw1o3ef2omk5n0nrf5fej
[INFO] MANAGER_IP_PORT is 10.0.31.3:2377
[INFO] WORKER_TOKEN is SWMTKN-1-4h8kibrmh79onbrwxj0l3y32sh9e8cwn25gschygpvfdgytjle-9runol5jrvwqf7fdozk5c0gng
[INFO] WORKER_IP_PORT is 10.0.31.3:2377

[INFO] Node manager2 is joining the swarm...
This node joined a swarm as a manager.
[INFO] Node manager3 is joining the swarm...
This node joined a swarm as a manager.

[INFO] Node worker1 is joining the swarm...
This node joined a swarm as a worker.
[INFO] Node worker2 is joining the swarm...
This node joined a swarm as a worker.
[INFO] Node worker3 is joining the swarm...
Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "": dial tcp: missing address
You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
Be advised that this will trigger a Docker daemon restart which might stop running containers.

Error response from daemon: This node is already part of a swarm. Use "docker swarm leave" to leave this swarm and join another one.


[INFO] Creating visualizer container...
o0e9pv8ps85cn3tzhhpwomvgf
```
# Remove all docker nodes at once in the current playground
```
$ docker-machine ls | tail -n+2 | awk '{print $1}' | xargs docker-machine rm -f
```

