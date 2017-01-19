Tools
=====


+-------------------------+--------------------------------------------------+----------------------------------------------------------------+
| Tool                    | Description                                      | Example Commands                                               |
+-------------------------+--------------------------------------------------+----------------------------------------------------------------+
| `seq2gfe`               | Whether the build is running inside RTD          | ``seq2gfe --seq GACGGCAA... -l HLA-A > seqtest1.gfe.csv``      |
+-------------------------+--------------------------------------------------+----------------------------------------------------------------+
| `fasta2gfe`             | The RTD name of the version which is being built | ``fasta2gfe --fasta test.fasta -l HLA-A > fastatest1.gfe.csv`` |
+-------------------------+--------------------------------------------------+----------------------------------------------------------------+
| `hml2gfe`               | The RTD name of the project which is being built | ``hml2gfe --input hmltest1.HML --hml > hmltest1.gfe.HML``      |
+-------------------------+--------------------------------------------------+----------------------------------------------------------------+


Installing Tools
--------------------------------

1) Clone github repository 
``git clone https://github.com/nmdp-bioinformatics/service-gfe-submission``

2) Change to the client-perl directory with the `Makefile.PL`. 
``cd service-gfe-sumission/client-perl``

3) Install cpanm and all the perl dependencies. 
``curl -LO http://xrl.us/cpanm && perl cpanm --notest --installdeps .``

4) Run `make test` and `make install`. 
``perl Makefile.PL && make && make test && make install``

seq2gfe
--------------------------------

 -s/--seq
	Sequence ** STDIN **
 -u/--uri
	URI of feature service
 -l/--locus
	HLA-Locus
 -v/--verbose
	Flag for running in verbose
 -h/--help
 	Flag for returning perldoc



fasta2gfe
--------------------------------

 -f/--fasta
	Fasta file ** STDIN **
 -u/--uri
	URI of feature service
 -l/--locus
	HLA-Locus
 -v/--verbose
	Flag for running in verbose
 -h/--help
 	Flag for returning perldoc


hml2gfe
--------------------------------

 -i/--input
	HML file
 -u/--uri
	URI of feature service
 -m/--hml
	flag for returning HML
 -v/--verbose
	Flag for running in verbose
 -h/--help
 	Flag for returning perldoc


