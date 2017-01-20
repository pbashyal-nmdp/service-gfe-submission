Clients
=======

Generating clients with Swagger
--------------------------------

    | "*Swagger is a specification and framework implementation* 
    |		*for describing, producing, consuming, and visualizing RESTful web services.*"

Creating new clients is easy when you use the `swagger.yaml` and Swagger autogeneration.
You can autogenerate clients using the `Swagger editor`_ or by locallying running the `Swagger autogeneration`_ tools.
Here I'll go through the steps for creating a new client using the GFE service `swagger.yaml` and the *Swagger editor*.

1) Go to the `Swagger editor`_.

2) Import the GFE service *swagger.yaml* by either pasting the text or by clicking *File* and then *Import URL*. Import the URL for the `raw text`_ of the `swagger.yaml`.

3) Click on *Generate Client* and then select the language you would like to use.

.. _Swagger editor: http://editor.swagger.io/
.. _Swagger autogeneration: http://editor.swagger.io/
.. _raw text: http://editor.swagger.io/

R Client
--------
.. note:: The R client hasn't been updated yet to include the nextflow APIs. Open the GfeClient.R script in the client-R directory to see all of the available functions.

The R client is available in the `client-R` directory in the github repositiory. 

Here are a few examples of installing and using the R client:

.. code-block:: R

	if (!is.installed('gfeClient')){
	    library(devtools)
	    install_github('nmdp-bioinformatics/service-gfe-submission/client-R')
	}
	library('gfeClient')

	host <- 'http://gfe.b12x.org/'

	# Get GFE from fasta file
	fasta.file <- 'GFE_Submission/t/resources/fastatest1.fasta'
	fasta.gfe  <- fasta2gfe(host,'HLA-A',fasta.file)

	# Get sequence from
	seq        <- gfe2seq(host,'HLA-A','HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1')

	# Get GFE from sequence
	gfe        <- seq2gfe(host,'HLA-A',seq)

	# return detailed logs
	verbose    <- 1
	gfe        <- seq2gfe(host,'HLA-A',seq,verbose)

	# Return structure (ex. exon, 1 , TGCCCAAGCCCCTCACCCTGAGATGGG)
	structure  <- 1
	gfe        <- seq2gfe(host,'HLA-A',seq,verbose,structure)



Perl Client
-----------

The perl client is available in the `client-perl` directory in the github repositiory. 

Here are a few examples of installing and using the perl client:

.. code-block:: perl

	#!/usr/bin/env perl
	use strict;
	use warnings;
	use GFE_Client;

	my $s_seq   = shift @ARGV;
	my $s_locus = shift @ARGV;

	# Does alignment of sequence and submission of aligned
	# sequence to the GFE service.
	my $o_client = GFE_Client->new();
	my $rh_gfe   = $o_client->getGfe($s_locus,$s_seq);

	# Print out GFE
	print $$rh_gfe{gfe},"\n";

