# service-gfe-submission

RESTful API and UI for getting GFE results from raw sequence data

[![Build Status](https://travis-ci.org/nmdp-bioinformatics/service-gfe-submission.svg?branch=master)](https://travis-ci.org/nmdp-bioinformatics/service-gfe-submission)[![Docs Status](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat)](http://service-gfe-submission.readthedocs.io/en/latest/index.html)[![Coverage Status](https://coveralls.io/repos/github/nmdp-bioinformatics/service-gfe-submission/badge.svg?branch=master)](https://coveralls.io/github/nmdp-bioinformatics/service-gfe-submission?branch=master)[![](https://images.microbadger.com/badges/version/nmdpbioinformatics/service-gfe-submission.svg)](https://microbadger.com/images/nmdpbioinformatics/service-gfe-submission "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/nmdpbioinformatics/service-gfe-submission.svg)](https://microbadger.com/images/nmdpbioinformatics/service-gfe-submission "Get your own image badge on microbadger.com")[![License](https://img.shields.io/badge/License-GNU%20General%20Public%20License%20v3.0-blue.svg)]()

##### Further documentation is available at [service-gfe-submission.readthedocs.io](http://service-gfe-submission.readthedocs.io/en/latest/index.html).
#

The Gene Feature Enumeration (GFE) Submission service provides an API for converting raw sequence data to GFE. It provides both a RESTful API and a simple user interface for converting raw sequence data to GFE results. Sequences can be submitted one at a time or as a fasta file. This service uses [nmdp-bioinformatics/service-feature](https://github.com/nmdp-bioinformatics/service-feature) for encoding the raw sequence data and [nmdp-bioinformatics/HSA](https://github.com/nmdp-bioinformatics/HSA) for aligning the raw sequence data. A public version of this service is available for use at [gfe.b12x.org](http://gfe.b12x.org). 


## RESTful Calls

```bash
    
# Get GFE from sequence data - in body #
curl --header "Content-type: application/json" --request POST  \
--data '{"locus":"HLA-A","sequence":"TCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCGGTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGACTGAG"}' \
http://gfe.b12x.org/gfe

# Sequence from GFE #
curl --header "Content-type: application/json" --request POST \
--data '{"locus":"HLA-A","gfe":"HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0"}' \
http://gfe.b12x.org/sequence

# Get GFE from fasta file #
curl -F "verbose=1" -F "locus=HLA-A" \
-F "file=@GFE_Submission/public/downloads/FastaTest.fasta" \
http://gfe.b12x.org/fasta

# Get GFE from HML file #
curl -F "verbose=1" \
-F "file=@GFE_Submission/public/downloads/HmlTest.HML" \
http://gfe.b12x.org/hml

# Get HML file with GFE from HML  #
curl -F "verbose=1" -F "type=xml" \
-F "file=@GFE_Submission/public/downloads/HmlTest.HML" \
http://gfe.b12x.org/hml

# Get HML file with GFE from HML using nextflow #
# Faster than /hml but can not provide structures #
curl -F "verbose=1" \
-F "file=@GFE_Submission/public/downloads/HmlTest.HML" \
http://gfe.b12x.org/flowhml

```

## Perl client example

```perl
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

```

## R client example

```R

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


```

### Tools

```bash
./fasta2gfe [--fasta] [--locus] [--uri] [--verbose] [--help]
            -f/--fasta      Fasta file ** STDIN **
            -u/--uri        URI of feature service
            -l/--locus      HLA-Locus
            -v/--verbose    Flag for running in verbose
            -h/--help

fasta2gfe --fasta t/resources/fastatest1.fasta -l HLA-A > fastatest1.gfe.csv
cat t/resources/fastatest1.fasta | fasta2gfe -l HLA-A > fastatest1.gfe.csv

```

```bash
./seq2gfe [--seq] [--locus] [--uri] [--verbose] [--help]
            -s/--seq        Sequence  ** STDIN **
            -u/--uri        URI of feature service
            -l/--locus      HLA-Locus
            -v/--verbose    Flag for running in verbose
            -h/--help

seq2gfe --seq GACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCT \
CTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTACCTGCGCT -l HLA-A > seqtest1.gfe.csv
cat GACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGC \
GGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTACCTGCGCTCTTGGACCGC | seq2gfe -l HLA-A > seqtest1.gfe.csv

```

```bash
./hml2gfe [--input] [--hml] [--uri] [--verbose] [--help]
            -i/--input      HML file
            -u/--uri        URI of feature service
            -h/--hml        flag for returning HML
            -v/--verbose    Flag for running in verbose
            -h/--help

hml2gfe --input t/resources/hmltest1.HML > hmltest1.gfe.csv
hml2gfe --input t/resources/hmltest1.HML --hml > hmltest1.gfe.HML

```

## Installing and Running Service Locally

```bash
perl cpanm --installdeps .   # Install perl dependencies
perl Makefile.PL             # Generate Makefile
make                         # Make menefest
make test                    # Run tests
make install                 # Install
plackup -E deployment  \     # Deploy
-s Starman --workers=10 \
-p 5050:8080 -a bin/app.pl      
```

## Docker

```bash
docker pull nmdpbioinformatics/service-gfe-submission
docker run -d --name service-gfe-submission -p 8080:5050 nmdpbioinformatics/service-gfe-submission
```
[Click here](https://hub.docker.com/r/nmdpbioinformatics/service-gfe-submission/) for more information on the publically available docker image. 


### Required Software

 * [Git](http://git.org)
 * [clustalo](http://www.clustal.org/omega)
 * [hap1.2](https://github.com/nmdp-bioinformatics/HSA)
 * [perl 5.18 or later](http://perl.org)
 * [nextflow](http://nextflow.io)

### Related Links

 * [hub.docker.com/r/nmdpbioinformatics/service-gfe-submission](https://hub.docker.com/r/nmdpbioinformatics/service-gfe-submission)
 * [service-gfe-submission.readthedocs.io](https://service-gfe-submission.readthedocs.io/en/latest/index.html)
 * [github.com/nmdp-bioinformatics/service-feature](https://github.com/nmdp-bioinformatics/service-feature)
 * [github.com/nmdp-bioinformatics/HSA](https://github.com/nmdp-bioinformatics/HSA)
 * [bioinformatics.bethematchclinical.org](https://bioinformatics.bethematchclinical.org)
 * [feature.nmdp-bioinformatics.org](https://feature.nmdp-bioinformatics.org)
 * [gfe.b12x.org](http://gfe.b12x.org)

<p align="center">
  <img src="https://bethematch.org/content/site/images/btm_logo.png">
</p>



