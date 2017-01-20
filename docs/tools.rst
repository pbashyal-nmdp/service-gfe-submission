Tools
=====

In the client-perl directory there are three command line tools available. 

Three `Perl` based tools are available in the client-perl directory in the GFE Service repository. 
When running these tools you can specify which `feature-service` and `gfe-service` to use. 
Without specifying they default to [feature.nmdp-bioinformatics.org](feature.nmdp-bioinformatics.org) and [gfe.b12x.org](https://gfe.b12x.org).

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

+-------------+------------------------------------------+----------------------------------------------------------------+
| **Tool**    | **Description**                          | **Example Commands**                                           |
+-------------+------------------------------------------+----------------------------------------------------------------+
| `seq2gfe`   | Convert sequence one at a time to GFE    | ``seq2gfe --seq GACGGCAA... -l HLA-A > seqtest1.gfe.csv``      |
+-------------+------------------------------------------+----------------------------------------------------------------+
| `fasta2gfe` | Convert sequences in a fasta file to GFE | ``fasta2gfe --fasta test.fasta -l HLA-A > fastatest1.gfe.csv`` |
+-------------+------------------------------------------+----------------------------------------------------------------+
| `hml2gfe`   | Convert sequences in a HML file to GFE   | ``hml2gfe --input hmltest1.HML --hml > hmltest1.gfe.HML``      |
+-------------+------------------------------------------+----------------------------------------------------------------+


seq2gfe
~~~~~~~

--seq
	Sequence ** STDIN **
--uri
	URI of feature service
--locus
	HLA-Locus
--verbose
	Flag for running in verbose
--help
 	Flag for returning perldoc

-s/--seq   Output all.
-b         Output both (this description is
           quite long).
-c arg     Output just arg.
--long     Output all day long.

-u/--uri   This option has two paragraphs in the description.
           This is the first.

           This is the second.  Blank lines may be omitted between
           options (as above) or left in (as here and below).

-p         This option has two paragraphs in the description.
           This is the first.

           This is the second.  Blank lines may be omitted between
           options (as above) or left in (as here and below).

-p         This option has two paragraphs in the description.
           This is the first.

           This is the second.  Blank lines may be omitted between
           options (as above) or left in (as here and below).          

fasta2gfe
~~~~~~~~~~~~~~

--fasta
	Fasta file ** STDIN **
--uri
	URI of feature service
--locus
	HLA-Locus
--verbose
	Flag for running in verbose
--help
 	Flag for returning perldoc


hml2gfe
~~~~~~~~~~~~~~

 --input
	HML file
 --uri
	URI of feature service
 --hml
	flag for returning HML
 --verbose
	Flag for running in verbose
 --help
 	Flag for returning perldoc


