# Docker

This page walks through how to build the service-gfe-submission docker image and how to run the service.

### Building Docker Image
```bash
# -t name_of_service:build_tag
# . location of Dockerfile
docker build -t service-gfe-submssion:latest .
```
If the docker image is successfuly built then typing `docker images` will show a new image labeled service-gfe-submission. 

### Running Service
```bash
# -d runs the service in the background
# --name name given to the executed container
# -p exposed ports, meaning service will be found at http://localhost:8080
# service-gfe-submission:latest name of the image you're executing
docker run -d --name service-gfe-submission -p 5050:8080 service-gfe-submission:latest
```
If the docker container is successfuly executed then typing `docker ps -a` will show a new container labeled service-gfe-submission running. 

### Debugging
```bash
# --rm removes container after you exit
# -it runs it interactively
# /bin/bash allows you to enter the docker container
docker run --rm -it service-gfe-submission:latest /bin/bash
```
[Click here](https://hub.docker.com/r/nmdpbioinformatics/service-gfe-submission/) for more information on the publically available docker image. 


