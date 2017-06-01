Docker
=======

.. note:: Running and installing docker requires sudo access on the machine you're using.

This page walks through how to build the service-gfe-submission docker image and how to run the service from the docker image.
To install docker, go to the `Docker homepage`_ and follow the installation process for the operating system you're using.


Building Docker Image Locally
-----------------------------
Only build the docker image locally if you're making changes to the service and are trying to do some debugging. 

.. code-block:: shell

	cd service-gfe-submission/docker
	docker build -t service-gfe-submssion:latest .

If the docker image is successfuly built then typing ``docker images`` will show a new image labeled service-gfe-submission. 
For running this image follow the instructions below, except remove the *nmdpbioinformatics* from the image name.

Pulling the Image
----------------------
The easiest way to get the service running locally, is to pull an image containing the service from docker hub. 
Running the following command will pull the latest GFE service image from docker hub.
The image on docker hub is built from the *Dockerfile* in the *docker* directory in the github repository.
Every new commit to the *nmdp-bioinformatics/service-gfe-submission* repository triggers a new build of the docker image on docker hub.

`Click here`_ for more information on the publically available docker image. 

.. tip:: If you want a particular verison of the GFE service, then you can specify what release version after the name in place of *latest*.

.. code-block:: shell

	docker pull nmdpbioinformatics/service-gfe-submission


Running Service
----------------------
Once the image is successfuly pulled to your machine you can run the service using the 

.. code-block:: shell

	docker run -d --name service-gfe-submission -p 8080:5050 nmdpbioinformatics/service-gfe-submission

The *-d* flag runs the service in "detached-mode" in the background and *-p* specifies what ports to expose. 
Make sure the ports you expose are not already in use.
If the docker container is successfuly executed then typing ``docker ps -a`` will show a new container labeled *service-gfe-submission* running. 


Debugging
----------------------
.. tip:: The JSON parsing tool **jq** can be useful for parsing through the JSON docker logs.

If you want to stop and delete a currently running docker container, then run ``docker ps`` to find the container id and then run the following command.

.. code-block:: shell

	docker kill {container id}
	docker rm   {container id}

New releases of the GFE service will be available on docker hub in the coming months and can be pulled using the same command from above.
Any new version you pull will have to be run with different ports or you will need to kill the container running the service. 
If you encounter an error while running the service that isn't 

.. code-block:: shell

	docker run --rm -it service-gfe-submission:latest /bin/bash

This allows you to enter the image through bash and access all of the files and programs installed on the image.
If something is failing when you try to run the service, then try and run the service from within the image.

Refer to the `docker documentation`_ for more information on using docker.

.. _Click here: https://hub.docker.com/r/nmdpbioinformatics/service-gfe-submission/
.. _Docker homepage: http://editor.swagger.io/
.. _Swagger autogeneration: http://editor.swagger.io/
.. _raw text: http://editor.swagger.io/
.. _docker documentation: https://docs.docker.com/engine/reference/commandline/cli/

