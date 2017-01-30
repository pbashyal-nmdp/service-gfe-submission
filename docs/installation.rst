Installation
=============

.. note:: The following instructions are for installing and running the service locally for **development purposes**. If you just want to run the service locally, then refer to the documentaiton on running the :doc:`docker` image instead.

Software Requirements
--------------------------
Before installing the GFE service locally, you'll need to install some required software. 
If you want to reproduce the GFE service locally, then installing the *ngs-tools* and *annotation pipeline* from the file available in the docker directory is the safest method.

    * `Git`_
    * `Perl`_
    * `Java`_
    * `Annotation Pipeline`_
    * `nextflow`_
    * `ngs-tools`_

.. _ngs-tools: https://github.com/nmdp-bioinformatics/ngs
.. _nextflow: http://www.python.org
.. _Annotation Pipeline: http://www.python.org
.. _Java: http://www.python.org
.. _Perl: http://www.python.org
.. _Git: http://www.python.org

Perl Packages
-----------------------------
.. tip:: Some perl modules will fail to load if you don't have certain software installed. Make sure you have `libssl-dev` installed otherwise *Moose* and *Log4j* will fail to properly install.

1) Clone the `github repository`_

2) Change into the *service-gfe-submission directory, with the `Makefile.PL` file.

3) Install cpanm and all the perl dependencies. ``curl -LO http://xrl.us/cpanm && perl cpanm --notest --installdeps .``

ngs-tools
-----------------------------
There are several ways that you can build the ngs-tools needed for running the GFE service. 
The easiest and safest way would be to install from the debian file located in the docker directory. 
Make sure to export the location the ngs-tools in your ``PATH`` environment variable.

Installing From Debian
~~~~~~~~~~~~~~~~~~~~~~~~
If you're not worried about the mechanics of the ngs-tools, then installing it from the debian file located in the docker directory is the best method.
Don't use this debian for the testing and development of the ngs-tools. 

.. code-block:: shell

	cd service-gfe-submission/docker
	dpkg --install ngs-tools_1.9.deb

Building locally
~~~~~~~~~~~~~~~~~~~~~~~~
If you want to make some modifications to the ngs-tools and test it locally with the GFE service, then this is the best option for you.
If you think the changes you make should be part of the ngs code base, then make sure to make a pull request to the ngs master branch on github.

.. code-block:: shell

	git clone https://github.com/nmdp-bioinformatics/ngs
	cd ngs
	mvn install


Annotation Pipeline
-----------------------------
Currently the annotaion pipeline is not able to be built from the github page.
Instead you can install it locally, by unzipping the tar file in the docker directory.
We're currently working on adding this to the ngs code base on github.

.. code-block:: shell

	cd service-gfe-submission/docker 
	tar -xzf hap1.2.tar.gz
	export PATH=$PATH:`pwd`


Installing service-gfe-submission
---------------------------------
.. note:: This step will fail if you don't have the required software listed above installed and listed in the ``PATH`` environment variable. Make sure to add the *nextflow*, *anootation pipeline* and the *ngs-tools* to your ``PATH`` environment variable.

1) Clone the github repository.

2) Change to the directory of the `Makefile.PL`.

3) Run `make test` and `make install`. ``perl Makefile.PL && make && make test && make install``

4) Run the service locally. ``plackup bin/app.pl``

5) Go to http://localhost:5000 for the GUI and access to the Swagger API.

6) Now test the service with ``curl``. 

.. code-block:: shell

	curl --header "Content-type: application/json" --request POST \
	--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
	http://localhost:5000/sequence





