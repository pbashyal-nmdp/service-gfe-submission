# service-gfe-submission

[![Build Status](https://travis-ci.org/nmdp-bioinformatics/service-gfe-submission.svg?branch=master)](https://travis-ci.org/nmdp-bioinformatics/service-gfe-submission)[![](https://images.microbadger.com/badges/image/nmdpbioinformatics/service-gfe-submission.svg)](https://microbadger.com/images/nmdpbioinformatics/service-gfe-submission "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/nmdpbioinformatics/service-gfe-submission.svg)](https://microbadger.com/images/nmdpbioinformatics/service-gfe-submission "Get your own version badge on microbadger.com")

RESTful Service getting GFE results from raw sequence data

Further documentation is available at [service-gfe-submission.readthedocs.io](http://service-gfe-submission.readthedocs.io/en/latest/index.html)

## REST Calls

```bash
    
# Get GFE from sequence data #
curl --header "Content-type: application/json" --request POST 
--data '{"locus":"HLA-A","sequence":"TCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCT
GCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGC
AAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCA
GGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGG
ACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCC
GGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTAC
AACCAGAGCGAGGCCGGTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACA
GTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTC
ATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCC
AGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTAC
GACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGT
GGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGG
GAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACA
AGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCC
TGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGA
TCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGC
TTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTT
CCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTG
TCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCC
CGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTA
CCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGG
GATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTC
TGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGA
CCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATT
GCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAG
GGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAA
GCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGG
ACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACC
TCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGG
AAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCT
TCTCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGT
GTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTT
TGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGACCTAATGT
GTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTT
TAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGA
CTGAG"}'
http://localhost:5000/api/v1/gfe

```

## Perl client example

```perl

#!/usr/bin/env perl
=head1 NAME
 
 	examples/ex1-client.pl
	
=head1 SYNOPSIS
	
	Simple perl script for turning raw sequence data
	into GFE annotation. 
 
=cut
use strict;
use warnings;
use GFE_Client;

our($s_locus,$s_seq,$s_url) = (undef,undef,undef);
&GetOptions('locus|l=s'     => \$s_locus,
			'seq|s=s'       => \$s_seq,
			'url|u=s'       => \$s_url
            );

# Does alignment of sequence and submission of aligned
# sequence to the GFE service.
my $rh_gfe = GFE_Client::getGfe($s_locus,$s_seq,$s_url,$s_feature_url);;

# Print out GFE
print $$rh_gfe{gfe},"\n";

```

## Perl local example

```perl

#!/usr/bin/env perl
=head1 NAME
 
 	examples/ex2-localgfe.pl
	
=head1 SYNOPSIS
	
	Simple perl script for turning raw sequence data
	into GFE annotation. 

	*************************************************
	** This requires clustalo and hap1.0.jar to be **
	** locally installed. ***************************
	*************************************************
 
=cut
use strict;
use warnings;
use Getopt::Long;
use FindBin;
use lib "$FindBin::Bin/../lib";
use GFE;

our($s_locus,$s_seq,$s_url) = (undef,undef,undef);
&GetOptions('locus|l=s'     => \$s_locus,
			'seq|s=s'       => \$s_seq,
			'url|u=s'       => \$s_url
            );

my $o_gfe = GFE->new();

# Defaults to http://feature.nmdp-bioinformatics.org
$o_gfe->client(url => $s_url) if defined $s_url;

# Does alignment of sequence and submission of aligned
# sequence to the GFE service.
my $rh_gfe = $o_gfe->getGfe($s_locus,$s_seq);

# Print out GFE
print $$rh_gfe{gfe},"\n";

```

### Tools

```bash
./gfe-submission [--fasta] [--uri] [--verbose] [--help]
            -f/--fasta      Fasta file
            -u/--uri        URI of feature service
            -l/--locus      HLA-Locus
            -v/--verbose    Flag for running in verbose
            -h/--help

gfe-submission --fasta t/resources/A.test1.fasta -l HLA-A -v 2> test1.gfe.log > test1.gfe.csv

```


## Running

```bash
perl Makefile.PL
make
make test
make install
plackup -E deployment -s Starman --workers=10 -p 5050 -a bin/app.pl
```


## Docker

```perl
docker pull nmdpbioinformatics/service-gfe-submission
docker run -d --name service-gfe-submission -p 80:8080 -p 81:8081 service-gfe-submission:latest
```

### Required Software

 * Git, http://git.org
 * clustalo, http://www.clustal.org/omega
 * hap1.0, https://github.com/wwang-nmdp/HSA/tree/SeqAnn
 * perl 5.18 or later, http://perl.org

### Dockerhub

[hub.docker.com/](https://hub.docker.com/r/nmdpbioinformatics/service-gfe-submission/)

### Perl Modules

 * YAML 
 * Plack 
 * Plack::Handler::Starman 
 * Template 
 * JSON
 * Moose
 * Dancer
 * Getopt::Long 
 * LWP::UserAgent 
 * Test::More
 * Dancer::Plugin::Swagger
 * Log::Log4perl
 * Net::SSLeay
 * JSON::Schema::AsType
 * IO::Socket::SSL
 * REST::Client
 * Math::Round
