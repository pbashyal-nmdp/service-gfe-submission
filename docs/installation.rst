Installation
=============

The following instructions are for installing and running the service locally for development purposes.
If you just want to run the service locally, then refer to the documentaiton on running the Docker image instead.

Software Requirements
--------------------------

    * Git
    * Perl
    * Java
    * HSA
    * nextflow
    * ngs-tools


Perl Packages
-----------------------------
.. note:: Some perl modules will fail to load if you don't have certain software installed. Make sure you have `libssl-dev` installed otherwise *Moose* and *Log4j* will fail to properly install.

1) Clone github repository ``git clone ``

2) Change to the directory of the `Makefile.PL`. 
``cd service-gfe-sumission/GFE_Submission``

3) Install cpanm and all the perl dependencies. 
``curl -LO http://xrl.us/cpanm && perl cpanm --notest --installdeps .``


ngs-tools
-----------------------------

There are several ways that you can build the ngs-tools needed for running the *GFE service*. 
I'll list all three below, but the easiest and safest way would be to install from the debian file located in the docker directory. 

Installing From Debian
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell

	cd service-gfe-submission/docker
	dpkg --install /opt/ngs-tools_1.9.deb


Maven Central Repository
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell

	curl -OL http://search.maven.org/remotecontent?filepath=org/nmdp/ngs/ngs-tools/1.9.0/ngs-tools-1.9.0.deb
	dpkg --install ngs-tools-1.9.0.deb && rm ngs-tools-1.9.0.deb


Building locally
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell

	git clone https://github.com/nmdp-bioinformatics/ngs
	cd ngs
	mvn install


Annotation Pipeline
-----------------------------

Currently the annotaion pipeline is not able to be built from the github page.
Instead you can just install it locally, by unzipping the tar file in the docker directory.

.. code-block:: shell

	cd service-gfe-submission/docker 
	tar -xzf hap1.2.tar.gz
	export PATH=$PATH:`pwd`


Installing service-gfe-submission
---------------------------------
.. note:: This step will fail if you don't have the required software listed above installed and listed in the ``PATH`` environment variable. Make sure to add the *nextflow*, *HSA* and the *ngs-tools* to your ``PATH`` environment variable.

1) Clone github repository ``git clone ``

2) Change to the directory of the `Makefile.PL`. ``cd service-gfe-sumission/GFE_Submission``

3) Run `make test` and `make install`. ``perl Makefile.PL && make && make test && make install``

4) Run service locally. ``plackup bin/app.pl``

5) Go to http://localhost:5000 for the GUI and access to the Swagger API.

6) Test with curl. 
``curl --header "Content-type: application/json" --request POST \
--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
http://localhost:5000/sequence``



