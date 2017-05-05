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

```
# Remove all docker nodes at once in the current playground
```
$ docker-machine ls | grep " pwd " | awk '{print $1}' | xargs docker-machine rm -f
```

