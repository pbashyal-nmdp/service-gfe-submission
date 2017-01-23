Tools
=====

Three tools are available in the client-perl directory in the GFE Service github repository. 
When running these tools you can specify which `feature-service` and `gfe-service` to use. 
Without specifying they default to `feature.nmdp-bioinformatics.org`_ and `gfe.b12x.org`_.

.. _feature.nmdp-bioinformatics.org: http://feature.nmdp-bioinformatics.org
.. _gfe.b12x.org: ttps://gfe.b12x.org

Installing Tools
--------------------------------
.. note:: Some perl modules will fail to load if you don't have certain software installed. Make sure you have `libssl-dev` installed otherwise *Moose* and *Log4j* will fail to properly install.

1) Clone the github repository. 

2) Change to the client-perl directory with the `Makefile.PL`. 

3) Install cpanm and all the perl dependencies. ``curl -LO http://xrl.us/cpanm && perl cpanm --notest --installdeps .``

4) Run `make test` and `make install`. ``perl Makefile.PL && make && make test && make install``


Tool Documentation
--------------------------------


seq2gfe
~~~~~~~

.. tip:: Use seq2gfe for quickly investigating a particular sequence. Don't try to use it for bulk analysis of sequences.

+---------------+------------------------------------------+
| **Parameter** | **Description**                          | 
+---------------+------------------------------------------+
| -s/--seq      | Raw sequence text, defaults to ``STDIN`` |
+---------------+------------------------------------------+
| -u/--url      | URL for service, default is gfe.b12x.org |
+---------------+------------------------------------------+
| -l/--locus    | Gene locus                               | 
+---------------+------------------------------------------+
| -v/--verbose  | Flag for running in verbose              | 
+---------------+------------------------------------------+
| -h/--help     | Flag for returning the Perl POD          | 
+---------------+------------------------------------------+

Example commands:

.. code-block:: shell

	seq2gfe --seq GACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCT \
	CTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTACCTGCGCT -l HLA-A > seqtest1.gfe.csv
	cat GACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGC \
	GGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTACCTGCGCTCTTGGACCGC | seq2gfe -l HLA-A > seqtest1.gfe.csv


fasta2gfe
~~~~~~~~~~~~~~

+---------------+------------------------------------------+
| **Parameter** | **Description**                          | 
+---------------+------------------------------------------+
| -f/--fasta    | Fasta file, defaults to ``STDIN``        |
+---------------+------------------------------------------+
| -u/--url      | URL for service, default is gfe.b12x.org |
+---------------+------------------------------------------+
| -l/--locus    | Gene locus                               | 
+---------------+------------------------------------------+
| -v/--verbose  | Flag for running in verbose              | 
+---------------+------------------------------------------+
| -h/--help     | Flag for returning the Perl POD          | 
+---------------+------------------------------------------+

Example commands:

.. code-block:: shell

	fasta2gfe --fasta t/resources/fastatest1.fasta -l HLA-A > fastatest1.gfe.csv
	cat t/resources/fastatest1.fasta | fasta2gfe -l HLA-A > fastatest1.gfe.csv


hml2gfe
~~~~~~~~~~~~~~

+---------------+------------------------------------------+
| **Parameter** | **Description**                          | 
+---------------+------------------------------------------+
| -i/--input    | Input HML File                           |
+---------------+------------------------------------------+
| -u/--url      | URL for service, default is gfe.b12x.org |
+---------------+------------------------------------------+
| -m/--hml      | Flag for returning results in HML file   | 
+---------------+------------------------------------------+
| -v/--verbose  | Flag for running in verbose              | 
+---------------+------------------------------------------+
| -h/--help     | Flag for returning the Perl POD          | 
+---------------+------------------------------------------+

Example commands:

.. code-block:: shell

	hml2gfe --input t/resources/hmltest1.HML > hmltest1.gfe.csv
	hml2gfe --input t/resources/hmltest1.HML --hml > hmltest1.gfe.HML

