Tools
=====

Three `Perl` based tools are available in the client-perl directory in the GFE Service repository. 
When running these tools you can specify which `feature-service` and `gfe-service` to use. 
Without specifying they default to `feature.nmdp-bioinformatics.org`_ and `gfe.b12x.org`_.

.. _feature.nmdp-bioinformatics.org: http://feature.nmdp-bioinformatics.org
.. _gfe.b12x.org: ttps://gfe.b12x.org

Installing Tools
--------------------------------
.. note:: Some perl modules will fail to load if you don't have certain software installed. Make sure you have `libssl-dev` installed otherwise *Moose* and *Log4j* will fail to properly install.

1) Clone the github repository 

2) Change to the client-perl directory with the `Makefile.PL`. 

3) Install cpanm and all the perl dependencies.
``curl -LO http://xrl.us/cpanm && perl cpanm --notest --installdeps .``

4) Run `make test` and `make install`. 
``perl Makefile.PL && make && make test && make install``


Tool Documentation
--------------------------------


seq2gfe
~~~~~~~

+---------------+------------------------------------------+
| **Parameter** | **Description**                          | 
+---------------+------------------------------------------+
| -s/--seq      | Convert sequence one at a time to GFE    |
+---------------+------------------------------------------+
| -u/--uri      | Convert sequences in a fasta file to GFE |
+---------------+------------------------------------------+
| -l/--locus    | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+
| -v/--verbose  | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+
| -h/--help     | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+

Example commands:

.. code-block:: shell

	curl --header "Content-type: application/json" --request POST \
	--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
	http://localhost:5000/sequence

.. tip:: 

fasta2gfe
~~~~~~~~~~~~~~

+---------------+------------------------------------------+
| **Parameter** | **Description**                          | 
+---------------+------------------------------------------+
| -s/--seq      | Convert sequence one at a time to GFE    |
+---------------+------------------------------------------+
| -u/--uri      | Convert sequences in a fasta file to GFE |
+---------------+------------------------------------------+
| -l/--locus    | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+
| -v/--verbose  | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+
| -h/--help     | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+

Example commands:

.. code-block:: shell

	curl --header "Content-type: application/json" --request POST \
	--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
	http://localhost:5000/sequence


hml2gfe
~~~~~~~~~~~~~~

+---------------+------------------------------------------+
| **Parameter** | **Description**                          | 
+---------------+------------------------------------------+
| -s/--seq      | Convert sequence one at a time to GFE    |
+---------------+------------------------------------------+
| -u/--uri      | Convert sequences in a fasta file to GFE |
+---------------+------------------------------------------+
| -l/--locus    | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+
| -v/--verbose  | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+
| -h/--help     | Convert sequences in a HML file to GFE   | 
+---------------+------------------------------------------+

Example commands:

.. code-block:: shell

	curl --header "Content-type: application/json" --request POST \
	--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
	http://localhost:5000/sequence

