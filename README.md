# Mininet Docker Image
This contains the files to construct a mininet docker image that can execute
mininet simulated networks.

## Privileged Mode
It is important to run this container in Privileged mode (`--privileged`) so that if can manipulate the network interface properties and devices. I suspect this can also be achieved with the capabilities (`--cap-add`) features of docker, but this has not been investigated.

## Overview
This container by default executes the the mininet (`mn`) executable with the options to the docker run command passed as parameters to the mininet processes.

## Process Execution
If the first option to the docker run command begins with a `/`, it is assumed that this references a path to an executable and that executable is invoked with any other run time options to the docker container.

## URL Download and Execute
If the first option to the docker run command is a URL, hueristically determined, the file the URL references is downloaded and executed with any other run time options to the docker container. It is assumed that the URL references a python mininet script, but this is not verified.

## Security Concerns
Because this container can be use to download and run any executable from a given URL there are some security concerns as the downloaded executalbe could be malicious. As such please use caution when specifying a URL to download and run.
