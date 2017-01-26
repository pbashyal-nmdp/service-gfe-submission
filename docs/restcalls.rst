RESTful API
=========================

The GFE service is not intended to be used as GUI tool, even though that capability is present.
This service was built with the intention of exposing RESTful APIs for easy integration with any language and platform.
One of the best ways to become familiar with each API is to test them out using the Swagger GUI.
Below I'll walk through each API with specific examples that are available on the Swagger GUI. 
If you'd like to make some suggestions for changing or updating the Swagger spec, then go to the Swagger hub page and make your suggested change or open a issue on github.

* `POST /gfe`_
* `POST /sequence`_
* `POST /fasta`_
* `POST /hml`_
* `POST /flowhml`_
* `Error Response`_


.. tip:: I suggest always using the *verbose* parameter for more detailed documentation of any potentail errors.


.. _POST /gfe:

POST /gfe
----------
	
Converting a single sequence to GFE can be done by doing a POST to the *gfe* API. 
If you're looking to investigate the structure of a particular sequence then this API is what you should use. 
If you have a large number of sequences you need to convert to GFE then refer to the `fasta`_ or `hml`_ APIs.

The object model for the gfe API is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>GfeSubmission</b>{
		    <b>feature_url</b> (string, <i>optional</i>),
		    <b>locus</b> (string),
		    <b>retry</b> (integer, <i>optional</i>),
		    <b>sequence</b> (string),
		    <b>structures</b> (boolean, <i>optional</i>),
		    <b>verbose</b> (boolean, <i>optional</i>)
		}
	</pre>
	</div>

At the very minimum you only have you provide a sequence and a locus.
The *structures* parameter is for returning each part of the GFE allele.
By default it will always return the full structure, but you may want it to only return the GFE value if you are not concerned about each feature.
For instance, if you submit a sequence to the gfe API without providing the *structures* parameter then it will return the accession, rank, sequence, and term for each feature.
The *retry* parameter will set how many times you want the GFE service to retry a call to the feature service.
Occasionally the feature service does not respond on the first request, therefore multiple requests may be needed for a sequence. 
The default is *six* and should only be changed for debugging purposes.
Please let us know if the feature service is failing to return accession numbers. 

Here is an example of a JSON object that can be posted to the gfe API:

   .. sourcecode:: js

	{
	  "locus": "HLA-A",
	  "verbose":1,
	  "sequence": "TCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCGGTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGACTGAG"
	}


The reponse from the API will either be a GFE JSON object or an `error object`_. 
The reponse model for the gfe API is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>Gfe</b> {
		    <b>aligned</b> (number, <i>optional</i>),
		    <b>fullgene</b> (Structure, <i>optional</i>),
		    <b>gfe</b> (string),
		    <b>log</b> (Array[string], <i>optional</i>),
		    <b>structure</b> (Array[Structure], <i>optional</i>),
		    <b>version</b> (string) 
		}
		<b>Structure</b> {
		    <b>accession</b> (integer),
		    <b>rank</b> (integer),
		    <b>sequence</b> (string),
		    <b>term</b> (string) 
		}
	</pre>
	</div>

If you pass the *verbose* parameter to the API then the *log* field will be populated with the details of the run.
The reponse will always contain a *fullgene* object, which contains the accession number for the full gene sequence.
This accession number can be used to retrieve the sequence from the *feature-service*. 
The *aligned* represents what percent of the submitted sequence was able to be aligned to the reference.
If there is a large insertion or deletion in the submitted sequence, the *aligned* value should reflect that.

Here is the JSON that would be returned from posting the example JSON to the gfe API:

.. sourcecode:: js
	:emphasize-lines: 9

	{
	  "aligned": "1.000",
	  "fullgene": {
	    "accession": "1",
	    "rank": "1",
	    "sequence": "TCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCGGTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGACTGAG",
	    "term": "gene"
	  },
	  "gfe": "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	  "locus": "HLA-A",
	  "log": [
	    "2017/01/20 19:57:10 INFO> GFE.pm:1317 GFE::checkFile - File is valid",
	    "2017/01/20 19:57:10 INFO> GFE.pm:1331 GFE::checkFile - File is valid for fasta type",
	    "2017/01/20 19:57:16 INFO> GFE.pm:1209 GFE::checkExitStatus - Alignment ran successfully",
	    "2017/01/20 19:57:16 INFO> Annotate.pm:234 GFE::Annotate::alignment_file - Alignment file: /opt/hap1.2/GFE/parsed-local/9554_reformat.csv",
	    "2017/01/20 19:57:16 INFO> Annotate.pm:234 GFE::Annotate::alignment_file - Alignment file: /opt/hap1.2/GFE/parsed-local/9554_reformat.csv",
	    "2017/01/20 19:57:16 INFO> GFE.pm:1127 GFE::checkAlignmentFile - Generated alignment file: /opt/hap1.2/GFE/parsed-local/9554_reformat.csv",
	    "2017/01/20 19:57:16 INFO> Annotate.pm:234 GFE::Annotate::alignment_file - Alignment file: /opt/hap1.2/GFE/parsed-local/9554_reformat.csv",
	    "2017/01/20 19:57:16 INFO> GFE.pm:1010 GFE::checkResults - Successfully loaded results",
	    "2017/01/20 19:57:16 INFO> GFE.pm:1154 GFE::checkGfe - Generated GFE: HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1"
	  ],
	  "structure": [
	    {
	      "accession": "1",
	      "rank": "1",
	      "sequence": "TCCCCAGACGCCGAGG",
	      "term": "five_prime_UTR"
	    },
	    {
	      "accession": "1",
	      "rank": "1",
	      "sequence": "ATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGG",
	      "term": "exon"
	    },
	    {
	      "accession": "7",
	      "rank": "1",
	      "sequence": "GTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "20",
	      "rank": "2",
	      "sequence": "GCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCG",
	      "term": "exon"
	    },
	    {
	      "accession": "10",
	      "rank": "2",
	      "sequence": "GTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "32",
	      "rank": "3",
	      "sequence": "GTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGG",
	      "term": "exon"
	    },
	    {
	      "accession": "7",
	      "rank": "3",
	      "sequence": "GTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "rank": "4",
	      "sequence": "ACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGG",
	      "term": "exon"
	    },
	    {
	      "accession": "1",
	      "rank": "4",
	      "sequence": "GTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "rank": "5",
	      "sequence": "AGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAG",
	      "term": "exon"
	    },
	    {
	      "accession": "6",
	      "rank": "5",
	      "sequence": "GTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "rank": "6",
	      "sequence": "ATAGAAAAGGAGGGAGTTACACTCAGGCTGCAA",
	      "term": "exon"
	    },
	    {
	      "accession": "5",
	      "rank": "6",
	      "sequence": "GTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "3",
	      "rank": "7",
	      "sequence": "GCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAG",
	      "term": "exon"
	    },
	    {
	      "accession": "5",
	      "rank": "7",
	      "sequence": "GTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "rank": "8",
	      "sequence": "TGTGA",
	      "term": "exon"
	    },
	    {
	      "accession": "1",
	      "rank": "8",
	      "sequence": "GACAGCTGCCTTGTGTGGGACTGAG",
	      "term": "three_prime_UTR"
	    }
	  ],
	  "version": "1.1.1"
	}


You can generate the above JSON by running the following ``curl`` command:

.. code-block:: shell

	curl --header "Content-type: application/JSON" --request POST \
	--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
	http://gfe.b12x.org/gfe


.. _POST /sequence:

POST /sequence
--------------------

Converting a GFE allele back to its corresponding sequence can be done by using the sequence API.
This API allows you to get the full sequence that's associated with the GFE allele. 
When submitting a sequence, if the *aligned* value is less than 1 then you will not be able to get the complete sequence back from the GFE allele.
The *fullgene* accession number returned from the gfe API can be used to get back the full sequence from the feature service.

The object model for the sequence API is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>SequenceSubmission</b>{
		    <b>feature_url</b> (string, <i>optional</i>),
		    <b>locus</b> (string),
		    <b>retry</b> (integer, <i>optional</i>),
		    <b>gfe</b> (string),
		    <b>structures</b> (boolean, <i>optional</i>),
		    <b>verbose</b> (boolean, <i>optional</i>)
		}
	</pre>
	</div>

At the very minimum you only have you provide a gfe and a locus. 
As with the gfe API, the structures of the GFE are returned by default.
Set the *structures* parameter to 0 if you don't care about each feature in the GFE allele.

Here is an example of a JSON object that can be posted to the sequence API:

.. sourcecode:: js

	{
	  "gfe": "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0",
	  "locus": "HLA-A",
	  "verbose": 1
	}


The reponse from the API will either be a Sequence JSON object or an error object. 
The GFE reponse object model is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>Sequence</b> {
		    <b>sequence</b> (string),
		    <b>log</b> (Array[string], <i>optional</i>),
		    <b>structure</b> (Array[Structure], <i>optional</i>),
		    <b>version</b> (string) 
		}
		<b>Structure</b> {
		    <b>accession</b> (integer),
		    <b>rank</b> (integer),
		    <b>sequence</b> (string),
		    <b>term</b> (string) 
		}
	</pre>
	</div>

Here is the JSON that would be returned from posting the above example JSON to the sequence API:

.. sourcecode:: js
   	:emphasize-lines: 6

	{
	  "log": [
	    "2017/01/20 19:34:30 INFO> GFE.pm:1154 GFE::checkGfe - Generated GFE: HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0",
	    "2017/01/20 19:34:30 WARN> GFE.pm:750 GFE::getSequence - Accession is not defined       - GFE:         HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"
	  ],
	  "sequence": "TCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCGGTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGA",
	  "structure": [
	    {
	      "accession": "1",
	      "locus": "HLA-A",
	      "rank": "1",
	      "sequence": "TCCCCAGACGCCGAGG",
	      "term": "five_prime_UTR"
	    },
	    {
	      "accession": "1",
	      "locus": "HLA-A",
	      "rank": "1",
	      "sequence": "ATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGG",
	      "term": "exon"
	    },
	    {
	      "accession": "7",
	      "locus": "HLA-A",
	      "rank": "1",
	      "sequence": "GTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "20",
	      "locus": "HLA-A",
	      "rank": "2",
	      "sequence": "GCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCG",
	      "term": "exon"
	    },
	    {
	      "accession": "10",
	      "locus": "HLA-A",
	      "rank": "2",
	      "sequence": "GTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "32",
	      "locus": "HLA-A",
	      "rank": "3",
	      "sequence": "GTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGG",
	      "term": "exon"
	    },
	    {
	      "accession": "7",
	      "locus": "HLA-A",
	      "rank": "3",
	      "sequence": "GTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "locus": "HLA-A",
	      "rank": "4",
	      "sequence": "ACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGG",
	      "term": "exon"
	    },
	    {
	      "accession": "1",
	      "locus": "HLA-A",
	      "rank": "4",
	      "sequence": "GTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "locus": "HLA-A",
	      "rank": "5",
	      "sequence": "AGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAG",
	      "term": "exon"
	    },
	    {
	      "accession": "6",
	      "locus": "HLA-A",
	      "rank": "5",
	      "sequence": "GTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "locus": "HLA-A",
	      "rank": "6",
	      "sequence": "ATAGAAAAGGAGGGAGTTACACTCAGGCTGCAA",
	      "term": "exon"
	    },
	    {
	      "accession": "5",
	      "locus": "HLA-A",
	      "rank": "6",
	      "sequence": "GTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAG",
	      "term": "intron"
	    },
	    {
	      "accession": "3",
	      "locus": "HLA-A",
	      "rank": "7",
	      "sequence": "GCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAG",
	      "term": "exon"
	    },
	    {
	      "accession": "5",
	      "locus": "HLA-A",
	      "rank": "7",
	      "sequence": "GTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAG",
	      "term": "intron"
	    },
	    {
	      "accession": "1",
	      "locus": "HLA-A",
	      "rank": "8",
	      "sequence": "TGTGA",
	      "term": "exon"
	    }
	  ],
	  "version": "1.0.7"
	}


You can generate the above JSON by running the following ``curl`` command:

.. code-block:: shell

	curl --header "Content-type: application/JSON" --request POST \
	--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
	http://gfe.b12x.org/sequence

.. _fasta:
.. _POST /fasta:

POST /fasta
--------------------

Converting a single sequence to GFE can be done by doing a POST to the gfe API.
The object model for the gfe API is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>FastaSubmission</b>{
		    <b>feature_url</b> (string, <i>optional</i>),
		    <b>locus</b> (string),
		    <b>retry</b> (integer, <i>optional</i>),
		    <b>file</b> (file),
		    <b>structures</b> (boolean, <i>optional</i>),
		    <b>verbose</b> (boolean, <i>optional</i>)
		}
	</pre>
	</div>

At the very minimum you only have you provide a gfe and a locus. 
I suggest always running it in verbose, so you can see more detailed documentation of any potentail errors.
The *structures* parameter is for returning each part of the GFE allele.
By default it will always return the full structure, but you may want it to only return the GFE value if you are not concerned about each feature.
For instance, if you submit a sequence to the gfe API without providing the *structures* parameter then it will return the accession, rank, sequence, and term for each feature.
The *retry* parameter will set how many times you want the GFE service to retry a call to the feature service.
Occasionally the feature service does not respond on the first request, therefore multiple may be needed for a sequence. 
The default is 6 and should only be changed for debugging purposes.
Here is an example of a JSON object that can be posted to the gfe API:

.. sourcecode:: js

	{
	  "file": "GFE_Submission/t/resources/fastatest1.fasta",
	  "locus": "HLA-A",
	  "verbose": 1
	}


The reponse from the API will either be a GFE JSON object or an error object. 
The GFE reponse object model is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>SubjectData</b>{
		    <b>log</b> (Array[string], <i>optional</i>),
		    <b>subjects</b> (Array[Subject]),
		    <b>version</b> (string, (string)
		}
		<b>Subject</b>{
		    <b>id</b> (string),
		    <b>typingData</b> (Array[TypingData])
		}
		<b>TypingData</b>{
		    <b>locus</b> (string),
		    <b>typing</b> (Array[Typing])
		}
		<b>Typing</b>{
		    <b>aligned</b> (number, <i>optional</i>),
		    <b>gfe</b> (string),
		    <b>imgthla</b> (string, <i>optional</i>),
		    <b>structure</b> (Array[Structure], <i>optional</i>)
		}
		<b>Structure</b> {
		    <b>accession</b> (integer),
		    <b>rank</b> (integer),
		    <b>sequence</b> (string),
		    <b>term</b> (string) 
		}
	</pre>
	</div>

Here is the JSON that would be returned from posting the above JSON object to the sequence API:

.. sourcecode:: js

	{
	   "log" : [
	      "2017/01/22 21:06:37 INFO> GFE.pm:1317 GFE::checkFile - File is valid",
	      "2017/01/22 21:06:37 INFO> GFE.pm:1331 GFE::checkFile - File is valid for fasta type",
	      "2017/01/22 21:06:37 INFO> Annotate.pm:190 GFE::Annotate::setFastaFile - Input file: public/downloads/fastatest1.fasta",
	      "2017/01/22 21:06:51 INFO> GFE.pm:1209 GFE::checkExitStatus - Alignment ran successfully",
	      "2017/01/22 21:06:51 INFO> Annotate.pm:234 GFE::Annotate::alignment_file - Alignment file: /Users/mhalagan/web_apps/devel/dancer-apps/service-gfe-upload/hap1.2/GFE/parsed-local/fastatest1_reformat.csv",
	      "2017/01/22 21:06:51 INFO> Annotate.pm:234 GFE::Annotate::alignment_file - Alignment file: /Users/mhalagan/web_apps/devel/dancer-apps/service-gfe-upload/hap1.2/GFE/parsed-local/fastatest1_reformat.csv",
	      "2017/01/22 21:06:51 INFO> GFE.pm:1127 GFE::checkAlignmentFile - Generated alignment file: /Users/mhalagan/web_apps/devel/dancer-apps/service-gfe-upload/hap1.2/GFE/parsed-local/fastatest1_reformat.csv",
	      "2017/01/22 21:06:56 INFO> Annotate.pm:234 GFE::Annotate::alignment_file - Alignment file: /Users/mhalagan/web_apps/devel/dancer-apps/service-gfe-upload/hap1.2/GFE/parsed-local/fastatest1_reformat.csv",
	      "2017/01/22 21:06:56 INFO> GFE.pm:1010 GFE::checkResults - Successfully loaded results",
	      "2017/01/22 21:06:56 INFO> GFE.pm:1154 GFE::checkGfe - Generated GFE: HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	      "2017/01/22 21:06:56 INFO> GFE.pm:1154 GFE::checkGfe - Generated GFE: HLA-Aw1-68-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	      "2017/01/22 21:06:56 INFO> GFE.pm:1154 GFE::checkGfe - Generated GFE: HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	      "2017/01/22 21:06:56 INFO> GFE.pm:1154 GFE::checkGfe - Generated GFE: HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1"
	   ],
	   "subjects" : [
	      {
	         "id" : "HLA-A*01:01:01",
	         "typingData" : [
	            {
	               "locus" : "HLA-A",
	               "typing" : [
	                  {
	                     "gfe" : "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	                     "structure" : [
	                        {
	                           "accession" : "1",
	                           "rank" : "1",
	                           "sequence" : "TCCCCAGACGCCGAGG",
	                           "term" : "five_prime_UTR"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "1",
	                           "sequence" : "ATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "1",
	                           "sequence" : "GTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "20",
	                           "rank" : "2",
	                           "sequence" : "GCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "10",
	                           "rank" : "2",
	                           "sequence" : "GTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "32",
	                           "rank" : "3",
	                           "sequence" : "GTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "3",
	                           "sequence" : "GTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "ACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "GTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "5",
	                           "sequence" : "AGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "6",
	                           "rank" : "5",
	                           "sequence" : "GTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "6",
	                           "sequence" : "ATAGAAAAGGAGGGAGTTACACTCAGGCTGCAA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "6",
	                           "sequence" : "GTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "3",
	                           "rank" : "7",
	                           "sequence" : "GCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "7",
	                           "sequence" : "GTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "TGTGA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "GACAGCTGCCTTGTGTGGGACTGAG",
	                           "term" : "three_prime_UTR"
	                        }
	                     ]
	                  }
	               ]
	            }
	         ]
	      },
	      {
	         "id" : "HLA-A*01:01:03",
	         "typingData" : [
	            {
	               "locus" : "HLA-A",
	               "typing" : [
	                  {
	                     "gfe" : "HLA-Aw1-68-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	                     "structure" : [
	                        {
	                           "accession" : "1",
	                           "rank" : "1",
	                           "sequence" : "TCCCCAGACGCCGAGG",
	                           "term" : "five_prime_UTR"
	                        },
	                        {
	                           "accession" : "68",
	                           "rank" : "1",
	                           "sequence" : "ATGGCCGTCATGGCCCAGACCTGGGCGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "1",
	                           "sequence" : "GTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "20",
	                           "rank" : "2",
	                           "sequence" : "GCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "10",
	                           "rank" : "2",
	                           "sequence" : "GTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "32",
	                           "rank" : "3",
	                           "sequence" : "GTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "3",
	                           "sequence" : "GTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "ACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "GTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "5",
	                           "sequence" : "AGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "6",
	                           "rank" : "5",
	                           "sequence" : "GTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "6",
	                           "sequence" : "ATAGAAAAGGAGGGAGTTACACTCAGGCTGCAA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "6",
	                           "sequence" : "GTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "3",
	                           "rank" : "7",
	                           "sequence" : "GCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "7",
	                           "sequence" : "GTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "TGTGA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "GACAGCTGCCTTGTGTGGGACTGAG",
	                           "term" : "three_prime_UTR"
	                        }
	                     ]
	                  }
	               ]
	            }
	         ]
	      },
	      {
	         "id" : "HLA-A*01:01:04",
	         "typingData" : [
	            {
	               "locus" : "HLA-A",
	               "typing" : [
	                  {
	                     "gfe" : "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	                     "structure" : [
	                        {
	                           "accession" : "1",
	                           "rank" : "1",
	                           "sequence" : "TCCCCAGACGCCGAGG",
	                           "term" : "five_prime_UTR"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "1",
	                           "sequence" : "ATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "1",
	                           "sequence" : "GTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "20",
	                           "rank" : "2",
	                           "sequence" : "GCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "10",
	                           "rank" : "2",
	                           "sequence" : "GTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "32",
	                           "rank" : "3",
	                           "sequence" : "GTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "3",
	                           "sequence" : "GTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "ACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "GTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "5",
	                           "sequence" : "AGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "6",
	                           "rank" : "5",
	                           "sequence" : "GTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "6",
	                           "sequence" : "ATAGAAAAGGAGGGAGTTACACTCAGGCTGCAA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "6",
	                           "sequence" : "GTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "3",
	                           "rank" : "7",
	                           "sequence" : "GCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "7",
	                           "sequence" : "GTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "TGTGA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "GACAGCTGCCTTGTGTGGGACTGAG",
	                           "term" : "three_prime_UTR"
	                        }
	                     ]
	                  }
	               ]
	            }
	         ]
	      },
	      {
	         "id" : "HLA-A*01:01:02",
	         "typingData" : [
	            {
	               "locus" : "HLA-A",
	               "typing" : [
	                  {
	                     "gfe" : "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1",
	                     "structure" : [
	                        {
	                           "accession" : "1",
	                           "rank" : "1",
	                           "sequence" : "TCCCCAGACGCCGAGG",
	                           "term" : "five_prime_UTR"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "1",
	                           "sequence" : "ATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "1",
	                           "sequence" : "GTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "20",
	                           "rank" : "2",
	                           "sequence" : "GCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "10",
	                           "rank" : "2",
	                           "sequence" : "GTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "32",
	                           "rank" : "3",
	                           "sequence" : "GTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "7",
	                           "rank" : "3",
	                           "sequence" : "GTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "ACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "4",
	                           "sequence" : "GTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "5",
	                           "sequence" : "AGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "6",
	                           "rank" : "5",
	                           "sequence" : "GTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "6",
	                           "sequence" : "ATAGAAAAGGAGGGAGTTACACTCAGGCTGCAA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "6",
	                           "sequence" : "GTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "3",
	                           "rank" : "7",
	                           "sequence" : "GCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAG",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "5",
	                           "rank" : "7",
	                           "sequence" : "GTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAG",
	                           "term" : "intron"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "TGTGA",
	                           "term" : "exon"
	                        },
	                        {
	                           "accession" : "1",
	                           "rank" : "8",
	                           "sequence" : "GACAGCTGCCTTGTGTGGGACTGAG",
	                           "term" : "three_prime_UTR"
	                        }
	                     ]
	                  }
	               ]
	            }
	         ]
	      }
	   ],
	   "version" : "1.0.7"
	}

You can generate the above JSON by running the following ``curl`` command:

.. code-block:: shell

	curl --header "Content-type: application/JSON" --request POST \
	--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
	http://gfe.b12x.org/gfe

.. _hml:
.. _POST /hml:

POST /hml
--------------------


The object model for the hml API is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>HmlSubmission</b>{
		    <b>feature_url</b> (string, <i>optional</i>),
		    <b>locus</b> (string),
		    <b>retry</b> (integer, <i>optional</i>),
		    <b>file</b> (file),
		    <b>structures</b> (boolean, <i>optional</i>),
		    <b>verbose</b> (boolean, <i>optional</i>)
		}
	</pre>
	</div>

Here is an example of a JSON object that can be posted to the gfe API:

.. sourcecode:: js

	{
	  "gfe": "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0",
	  "locus": "HLA-A",
	  "verbose": 1
	}


The reponse from the API will either be a GFE JSON object or an error object. 
The GFE reponse object model is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>SubjectData</b>{
		    <b>log</b> (Array[string], <i>optional</i>),
		    <b>subjects</b> (Array[Subject]),
		    <b>version</b> (string, (string)
		}
		<b>Subject</b>{
		    <b>id</b> (string),
		    <b>typingData</b> (Array[TypingData])
		}
		<b>TypingData</b>{
		    <b>locus</b> (string),
		    <b>typing</b> (Array[Typing])
		}
		<b>Typing</b>{
		    <b>aligned</b> (number, <i>optional</i>),
		    <b>gfe</b> (string),
		    <b>imgthla</b> (string, <i>optional</i>),
		    <b>structure</b> (Array[Structure], <i>optional</i>)
		}
		<b>Structure</b> {
		    <b>accession</b> (integer),
		    <b>rank</b> (integer),
		    <b>sequence</b> (string),
		    <b>term</b> (string) 
		}
	</pre>
	</div>


Here is the JSON that would be returned from posting the above JSON object to the sequence API:

.. _POST /flowhml:

POST /flowhml
--------------------

Converting a single sequence to GFE can be done by doing a POST to the gfe API.
The object model for the gfe API is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>HmlSubmission</b>{
		    <b>feature_url</b> (string, <i>optional</i>),
		    <b>locus</b> (string),
		    <b>retry</b> (integer, <i>optional</i>),
		    <b>file</b> (file),
		    <b>structures</b> (boolean, <i>optional</i>),
		    <b>verbose</b> (boolean, <i>optional</i>)
		}
	</pre>
	</div>


Here is an example of a JSON object that can be posted to the gfe API:

.. sourcecode:: js

	{
	  "gfe": "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0",
	  "locus": "HLA-A",
	  "verbose": 1
	}


The reponse from the API will either be a GFE JSON object or an error object. 
The GFE reponse object model is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>SequenceSubmission</b>{
		    <b>feature_url</b> (string, <i>optional</i>),
		    <b>locus</b> (string),
		    <b>retry</b> (integer, <i>optional</i>),
		    <b>gfe</b> (string),
		    <b>structures</b> (boolean, <i>optional</i>),
		    <b>verbose</b> (boolean, <i>optional</i>)
		}
	</pre>
	</div>

Here is the JSON that would be returned from posting the above JSON object to the sequence API:

.. _error object:
.. _Error Response:

Error Object
--------------------

Converting a single sequence to GFE can be done by doing a POST to the gfe API.
The model for the error reponse is as follows:

.. raw:: html

	<div style="font-family: monospace, serif;font-size:.9em;">
	<pre>
		<b>Error</b>{
		    <b>Message</b> (string),
		    <b>accession</b> (string, <i>optional</i>),
		    <b>file</b> (string, <i>optional</i>),
		    <b>gfe</b> (string, <i>optional</i>),
		    <b>log</b> (Array[string], <i>optional</i>),
		    <b>rank</b> (integer, <i>optional</i>),
		    <b>sequence</b> (string, <i>optional</i>),
		    <b>term</b> (string, <i>optional</i>),
		    <b>type</b> (string, <i>optional</i>),
		    <b>version</b> (string)
		}
	</pre>
	</div>


