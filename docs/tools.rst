Tools
=====

The *Sphinx* and *Mkdocs* builders set the following RTD-specific environment variables when building your documentation:

+-------------------------+--------------------------------------------------+----------------------+----------------------+
| Tool                    | Description                                      | Output               | Examples
+-------------------------+--------------------------------------------------+----------------------+----------------------+
| `seq2gfe`               | Whether the build is running inside RTD          | ``True``             |                      |
+-------------------------+--------------------------------------------------+----------------------+----------------------+
| `fasta2gfe`             | The RTD name of the version which is being built | ``latest``           |                      |
+-------------------------+--------------------------------------------------+----------------------+----------------------+
| `hml2gfe`               | The RTD name of the project which is being built | ``myexampleproject`` |                      |
+-------------------------+--------------------------------------------------+----------------------+----------------------+


Installing Tools
--------------------------------

1) Clone github repository ``git clone ``

2) Change to the client-perl directory with the `Makefile.PL`. ``cd service-gfe-sumission/client-perl``

3) Install cpanm and all the perl dependencies. ``curl -LO http://xrl.us/cpanm && perl cpanm --notest --installdeps .``

4) 

seq2gfe
--------------------------------


 --hml
	HML file 
 --output
	Output directory
 --imgtdir
	Location of where the BLAST IMGT database is located
 --imgt
	IMGT database version

 --report
	Binary flag for generating HTML validation report
	default is 1




fasta2gfe
--------------------------------


hml2gfe
--------------------------------

