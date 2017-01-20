Docker
=======
.. _Docker:

.. note:: Running and installing docker requires sudo access on the machine you're using.

This page walks through how to build the service-gfe-submission docker image and how to run the service.
To install docker, go to the `Docker homepage`_ and follow the installation process for whatever machine you're using.


Building Docker Image Locally
-----------------------------
Only build the docker image locally if you're making changes to the service and are trying to do some debugging.

.. code-block:: shell

	docker build -t service-gfe-submssion:latest .

If the docker image is successfuly built then typing ``docker images`` will show a new image labeled service-gfe-submission. 

Pulling the Image
----------------------
The easiest way to get the service running locally, is to pull an image containing the service from docker hub.

.. code-block:: shell

	docker run -d --name service-gfe-submission -p 5050:8080 service-gfe-submission:latest

.. tip:: If you want a particular verison of the GFE service, then you can specify what release version after the name in place of *latest*.


Running Service
----------------------
The easiest way to get the service running locally, is to pull an image containing the service from docker hub.

.. code-block:: shell

	docker pull nmdpbioinformatics/service-gfe-submission
	docker run -d --name service-gfe-submission -p 8080:5050 nmdpbioinformatics/service-gfe-submission

The *-d* flag runs the service in the background and *-p* specifies what ports to expose.
If the docker container is successfuly executed then typing ``docker ps -a`` will show a new container labeled service-gfe-submission running. 


Debugging
----------------------
.. code-block:: shell

	docker run --rm -it service-gfe-submission:latest /bin/bash

This allows you to enter the image through bash and access all of the files and programs installed on the image.
If something is failing when you try to run the service, then try and run the service from within the image.


`Click here`_ for more information on the publically available docker image. 


.. _Click here: https://hub.docker.com/r/nmdpbioinformatics/service-gfe-submission/
.. _Docker homepage: http://editor.swagger.io/
.. _Swagger autogeneration: http://editor.swagger.io/
.. _raw text: http://editor.swagger.io/
