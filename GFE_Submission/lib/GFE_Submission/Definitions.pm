#!/usr/bin/env perl
=head1 NAME
 
    GFE_Submission::Definitions.pm

=head1 SYNOPSIS

    

=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

=head1 LICENSE

    Copyright (c) 2016 National Marrow Donor Program (NMDP)

    This library is free software; you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License as published
    by the Free Software Foundation; either version 3 of the License, or (at
    your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; with out even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
    License for more details.
 
    You should have received a copy of the GNU Lesser General Public License
    along with this library;  if not, write to the Free Software Foundation,
    Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA.

    > http://www.gnu.org/licenses/lgpl.html

=head1 DEFINITIONS

=cut
package GFE_Submission::Definitions;
use strict;
use warnings;

use Dancer ':syntax';
use Dancer::Plugin::Swagger;



=head2 GfeSubmission


=cut
swagger_definition 'GfeSubmission' => {
    type => 'object',
    required   => [ 'locus','sequence'],
    properties => {
        locus      => { type => 'string'  },
        retry      => { type => 'integer' },
    	sequence   => { type => 'string'  },
    	url        => { type => 'string'  },
        verbose    => { type => 'boolean' },
        structures => { type => 'boolean' }
    },
    example => {
        locus   => 'HLA-A',
        sequence => 'TCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCGGTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGACTGAG',
    }
};


=head2 SequenceSubmission


=cut
swagger_definition 'SequenceSubmission' => {
    type => 'object',
    required   => [ 'gfe','locus'],
    properties => {
        locus      => { type => 'string'  },
        gfe        => { type => 'string'  },
        retry      => { type => 'integer' },
        url        => { type => 'string'  },
        verbose    => { type => 'boolean' },
        structures => { type => 'boolean' }
    },
    example => {
        locus   => 'HLA-A',
        gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-0',
        verbose => 1
    }
};


=head2 FastaSubmission


=cut
swagger_definition 'FastaSubmission' => {
    type => 'object',
    required   => [ 'locus','file'],
    properties => {
        locus      => { type => 'string'  },
        retry      => { type => 'integer' },
        file       => { type => 'file'  },
        url        => { type => 'string'  },
        verbose    => { type => 'boolean' },
        structures => { type => 'boolean' }
    },
    example => {
        locus      => 'HLA-A',
        file       => 'public/downloads/FastaTest.fasta',
        verbose    => 1,
        structures => 1
    }
};

=head2 HmlSubmission


=cut
swagger_definition 'HmlSubmission' => {
    type => 'object',
    required   => ['file'],
    properties => {
        retry      => { type => 'integer' },
        file       => { type => 'file'  },
        url        => { type => 'string'  },
        type       => { type => 'string'  },
        verbose    => { type => 'boolean' },
        structures => { type => 'boolean' }
    },
    example => {
        file      => 'public/downloads/HmlTest.Hml',
        verbose    => 1,
        structures => 1
    }
};

=head2 Sequence


=cut
swagger_definition 'Sequence' => {
    type => 'object',
    required   => [ 'sequence','version' ],
    properties => {
        sequence => { type => 'string' },
        log => { type => 'array',
            items => { type => 'string' }
        },
        structure => { type => 'array',
            items => {'$ref' => "#/definitions/Structure" }
        },
        version => { type => 'string' },
    },
    example => {
        sequence   => 'TCCCCAGACGCCGAGGATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGGGTGAGTGCGGGGTCGGGAGGGAAACCGCCTCTGCGGGGAGAAGCAAGGGGCCCTCCTGGCGGGGGCGCAGGACCGGGGGAGCCGCGCCGGGACGAGGGTCGGGCAGGTCTCAGCCACTGCTCGCCCCCAGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGCCGCGGGGAGCCCCGCTTCATCGCCGTGGGCTACGTGGACGACACGCAGTTCGTGCGGTTCGACAGCGACGCCGCGAGCCAGAGGATGGAGCCGCGGGCGCCGTGGATAGAGCAGGAGGGGCCGGAGTATTGGGACCAGGAGACACGGAATGTGAAGGCCCAGTCACAGACTGACCGAGTGGACCTGGGGACCCTGCGCGGCTACTACAACCAGAGCGAGGCCGGTGAGTGACCCCGGCCGGGGGCGCAGGTCAGGACCCCTCATCCCCCACGGACGGGCCAGGTCGCCCACAGTCTCCGGGTCCGAGATCCACCCCGAAGCCGCGGGACCCCGAGACCCTTGCCCCGGGAGAGGCCCAGGCGCCTTTACCCGGTTTCATTTTCAGTTTAGGCCAAAAATCCCCCCGGGTTGGTCGGGGCTGGGCGGGGCTCGGGGGACTGGGCTGACCGCGGGGTCGGGGCCAGGTTCTCACACCATCCAGATAATGTATGGCTGCGACGTGGGGTCGGACGGGCGCTTCCTCCGCGGGTACCGGCAGGACGCCTACGACGGCAAGGATTACATCGCCCTGAACGAGGACCTGCGCTCTTGGACCGCGGCGGACATGGCGGCTCAGATCACCAAGCGCAAGTGGGAGGCGGCCCATGAGGCGGAGCAGTTGAGAGCCTACCTGGATGGCACGTGCGTGGAGTGGCTCCGCAGATACCTGGAGAACGGGAAGGAGACGCTGCAGCGCACGGGTACCAGGGGCCACGGGGCGCCTCCCTGATCGCCTGTAGATCTCCCGGGCTGGCCTCCCACAAGGAGGGGAGACAATTGGGACCAACACTAGAATATCACCCTCCCTCTGGTCCTGAGGGAGAGGAATCCTCCTGGGTTCCAGATCCTGTACCAGAGAGTGACTCTGAGGTTCCGCCCTGCTCTCTGACACAATTAAGGGATAAAATCTCTGAAGGAGTGACGGGAAGACGATCCCTCGAATACTGATGAGTGGTTCCCTTTGACACCGGCAGCAGCCTTGGGCCCGTGACTTTTCCTCTCAGGCCTTGTTCTCTGCTTCACACTCAATGTGTGTGGGGGTCTGAGTCCAGCACTTCTGAGTCCCTCAGCCTCCACTCAGGTCAGGACCAGAAGTCGCTGTTCCCTTCTCAGGGAATAGAAGATTATCCCAGGTGCCTGTGTCCAGGCTGGTGTCTGGGTTCTGTGCTCTCTTCCCCATCCCGGGTGTCCTGTCCATTCTCAAGATGGCCACATGCGTGCTGGTGGAGTGTCCCATGACAGATGCAAAATGCCTGAATTTTCTGACTCTTCCCGTCAGACCCCCCCAAGACACATATGACCCACCACCCCATCTCTGACCATGAGGCCACCCTGAGGTGCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGGGAGGACCAGACCCAGGACACGGAGCTCGTGGAGACCAGGCCTGCAGGGGATGGAACCTTCCAGAAGTGGGCGGCTGTGGTGGTGCCTTCTGGAGAGGAGCAGAGATACACCTGCCATGTGCAGCATGAGGGTCTGCCCAAGCCCCTCACCCTGAGATGGGGTAAGGAGGGAGATGGGGGTGTCATGTCTCTTAGGGAAAGCAGGAGCCTCTCTGGAGACCTTTAGCAGGGTCAGGGCCCCTCACCTTCCCCTCTTTTCCCAGAGCTGTCTTCCCAGCCCACCATCCCCATCGTGGGCATCATTGCTGGCCTGGTTCTCCTTGGAGCTGTGATCACTGGAGCTGTGGTCGCTGCCGTGATGTGGAGGAGGAAGAGCTCAGGTGGAGAAGGGGTGAAGGGTGGGGTCTGAGATTTCTTGTCTCACTGAGGGTTCCAAGCCCCAGCTAGAAATGTGCCCTGTCTCATTACTGGGAAGCACCGTCCACAATCATGGGCCTACCCAGTCTGGGCCCCGTGTGCCAGCACTTACTCTTTTGTAAAGCACCTGTTAAAATGAAGGACAGATTTATCACCTTGATTACGGCGGTGATGGGACCTGATCCCAGCAGTCACAAGTCACAGGGGAAGGTCCCTGAGGACAGACCTCAGGAGGGCTATTGGTCCAGGACCCACACCTGCTTTCTTCATGTTTCCTGATCCCGCCCTGGGTCTGCAGTCACACATTTCTGGAAACTTCTCTGGGGTCCAAGACTAGGAGGTTCCTCTAGGACCTTAAGGCCCTGGCTCCTTTCTGGTATCTCACAGGACATTTTCTTCTCACAGATAGAAAAGGAGGGAGTTACACTCAGGCTGCAAGTAAGTATGAAGGAGGCTGATGCCTGAGGTCCTTGGGATATTGTGTTTGGGAGCCCATGGGGGAGCTCACCCACCTCACAATTCCTCCTCTAGCCACATCTTCTGTGGGATCTGACCAGGTTCTGTTTTTGTTCTACCCCAGGCAGTGACAGTGCCCAGGGCTCTGATGTGTCCCTCACAGCTTGTAAAGGTGAGAGCTTGGAGGACCTAATGTGTGTTGGGTGTTGGGCGGAACAGTGGACACAGCTGTGCTATGGGGTTTCTTTGCATTGGATGTATTGAGCATGCGATGGGCTGTTTAAGGTGTGACCCCTCACTGTGATGGATATGAATTTGTTCATGAATATTTTTTTCTATAGTGTGAGACAGCTGCCTTGTGTGGGACTGAG',
        version => '1.0.0',
        structure  => [
            {
            term   => 'exon',
            rank   => 1,
            accession => 1,
            sequence => "ACTGACTG",
            locus => "HLA-A"
         },
         {  
            term   => 'exon',
            rank   => 2,
            accession => 23,
            sequence => "ACTGACTG",
            locus => "HLA-A"
          }
        ]
    }
};




=head2 Structure


=cut
swagger_definition 'Structure' => {
    type => 'object',
    required   => [ 'term','rank','accession','sequence' ],
    properties => {
        term => { type => 'string' },
        sequence => { type => 'string' },
        rank => { type => 'integer' },
        accession => { type => 'integer' },
    },
    example => {
        term   => 'exon',
        rank   => 1,
        accession => 1,
        sequence => "ACTGACTGACTGACTGACTGACTGACTGACTGACTGACTGACTGACTG",
        locus => "HLA-A"
    },
};




=head2 Subject


=cut
swagger_definition 'SubjectData' => {
    type => 'object',
    required   => [ 'subjects','version' ],
    properties => {
        version => { type => 'string' },
        log     => { type => 'array',
            items => { type => 'string' }
        },
        subjects => { type => 'array',
            items => {'$ref' => "#/definitions/Subject" }
        },
    },
    example => {
        log  => [
            "2016/11/15 17:37:16 INFO> Annotate.pm:167 GFE::Annotate::setInputFile   - Input file:      t/resources/HmlTest.HML",
            "2016/11/15 17:37:16 INFO> Annotate.pm:185 GFE::Annotate::alignment_file - Alignment file:  t/resources/HmlTest_reformat.csv"
            ],
        version   => '1.0.2',
        subjects  => [
            {
                id          => '111111',
                typingData  => [
                    {
                        locus   => 'HLA-A',
                        typing  => [
                            {
                                gfe     => 'HLA-Aw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "A*01:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },
                            {
                                gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "A*01:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },

                        ]
                    },
                    {
                        locus   => 'HLA-B',
                        typing  => [
                            {
                                gfe     => 'HLA-Bw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "B*04:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },
                            {
                                gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "B*05:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },

                        ]
                    },            
                ]
            },
            {
                id          => '222222222',
                typingData  => [
                    {
                        locus   => 'HLA-A',
                        typing  => [
                            {
                                gfe     => 'HLA-Aw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "A*01:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },
                            {
                                gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "A*01:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },

                        ]
                    },
                    {
                        locus   => 'HLA-B',
                        typing  => [
                            {
                                gfe     => 'HLA-Bw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "B*04:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },
                            {
                                gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "B*05:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },

                        ]
                    },            
                ]
            },
            {
                id          => '3333333333',
                typingData  => [
                    {
                        locus   => 'HLA-A',
                        typing  => [
                            {
                                gfe     => 'HLA-Aw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "A*01:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },
                            {
                                gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "A*01:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },

                        ]
                    },
                    {
                        locus   => 'HLA-B',
                        typing  => [
                            {
                                gfe     => 'HLA-Bw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "B*04:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },
                            {
                                gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                                imgthla => "B*05:01:01:01",
                                structure  => [
                                {
                                    term   => 'exon',
                                    rank   => 1,
                                    accession => 1,
                                    sequence => "ACTGACTG",
                                 },
                                 {  
                                    term   => 'exon',
                                    rank   => 2,
                                    accession => 23,
                                    sequence => "ACTGACTG"
                                  }
                                ]
                            },

                        ]
                    },            
                ]
            },            
        ]
    }
};


=head2 Subject


=cut
swagger_definition 'Subject' => {
    type => 'object',
    required   => [ 'id','typingData' ],
    properties => {
        id         => { type => 'string' },
        typingData => { type => 'array',
            items  => {'$ref' => "#/definitions/TypingData" }
        }
    },
    example => {
        id          => '012312A',
        typingData  => [
            {
                locus   => 'HLA-A',
                typing  => [
                    {
                        gfe     => 'HLA-Aw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                        imgthla => "A*01:01:01:01",
                        structure  => [
                        {
                            term   => 'exon',
                            rank   => 1,
                            accession => 1,
                            sequence => "ACTGACTG",
                         },
                         {  
                            term   => 'exon',
                            rank   => 2,
                            accession => 23,
                            sequence => "ACTGACTG"
                          }
                        ]
                    },
                    {
                        gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                        imgthla => "A*01:01:01:01",
                        structure  => [
                        {
                            term   => 'exon',
                            rank   => 1,
                            accession => 1,
                            sequence => "ACTGACTG",
                         },
                         {  
                            term   => 'exon',
                            rank   => 2,
                            accession => 23,
                            sequence => "ACTGACTG"
                          }
                        ]
                    },

                ]
            },
            {
                locus   => 'HLA-B',
                typing  => [
                    {
                        gfe     => 'HLA-Bw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                        imgthla => "B*04:01:01:01",
                        structure  => [
                        {
                            term   => 'exon',
                            rank   => 1,
                            accession => 1,
                            sequence => "ACTGACTG",
                         },
                         {  
                            term   => 'exon',
                            rank   => 2,
                            accession => 23,
                            sequence => "ACTGACTG"
                          }
                        ]
                    },
                    {
                        gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                        imgthla => "B*05:01:01:01",
                        structure  => [
                        {
                            term   => 'exon',
                            rank   => 1,
                            accession => 1,
                            sequence => "ACTGACTG",
                         },
                         {  
                            term   => 'exon',
                            rank   => 2,
                            accession => 23,
                            sequence => "ACTGACTG"
                          }
                        ]
                    },

                ]
            },            
        ]
    }
};


=head2 Subject


=cut
swagger_definition 'TypingData' => {
    type => 'object',
    required   => [ 'typing','locus' ],
    properties => {
        locus   => { type => 'string' },
        typing  => { type => 'array',
            items  => {'$ref' => "#/definitions/Typing" }
        },
    },
    example => {
        locus   => 'HLA-A',
        typing  => [
            {
                gfe     => 'HLA-Aw2-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                imgthla => "A*01:01:01:01",
                structure  => [
                {
                    term   => 'exon',
                    rank   => 1,
                    accession => 1,
                    sequence => "ACTGACTG",
                 },
                 {  
                    term   => 'exon',
                    rank   => 2,
                    accession => 23,
                    sequence => "ACTGACTG"
                  }
                ]
            },
            {
                gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
                imgthla => "A*02:01:01:01",
                structure  => [
                {
                    term   => 'exon',
                    rank   => 1,
                    accession => 1,
                    sequence => "ACTGACTG",
                 },
                 {  
                    term   => 'exon',
                    rank   => 2,
                    accession => 23,
                    sequence => "ACTGACTG"
                  }
                ]
            },

        ]
    }
};


=head2 Gfe


=cut
swagger_definition 'Typing' => {
    type => 'object',
    required   => [ 'gfe' ],
    properties => {
        gfe       => { type => 'string' },
        imgthla   => { type => 'string' },
        aligned   => { type => 'number' },
        structure => { type => 'array',
            items => {'$ref' => "#/definitions/Structure" }
        },
    },
    example => {
        gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
        version => '1.0.0',
        aligned => .95,
        locus   => "HLA-A",
        imgthla => "A*01:01:01:01",
        structure  => [
        {
            term   => 'exon',
            rank   => 1,
            accession => 1,
            sequence => "ACTGACTG",
         },
         {  
            term   => 'exon',
            rank   => 2,
            accession => 23,
            sequence => "ACTGACTG"
          }
        ]
    }
};


=head2 Gfe


=cut
swagger_definition 'Gfe' => {
    type => 'object',
    required   => [ 'gfe','version' ],
    properties => {
        gfe       => { type => 'string' },
        aligned   => { type => 'number' },
        version   => { type => 'string' },
        log       => { type => 'array',
           items  => { type => 'string' }
        },
        structure => { type => 'array',
            items => {'$ref' => "#/definitions/Structure" }
        },
    },
    example => {
        gfe     => 'HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1',
        version => '1.0.0',
        aligned => .95,
        locus   => "HLA-A",
        imgthla => "A*01:01:01:01",
        structure  => [
        {
            term   => 'exon',
            rank   => 1,
            accession => 1,
            sequence => "ACTGACTG",
         },
         {  
            term   => 'exon',
            rank   => 2,
            accession => 23,
            sequence => "ACTGACTG"
          }
        ]
    }
};


=head2 Error


=cut
swagger_definition 'Error' => {
    type => 'object',
    required   => [ 'Message','version' ],
    properties => {
        Message   => { type => 'string' },
        sequence  => { type => 'string' },
        type      => { type => 'string' },
        accession => { type => 'string' },
        file      => { type => 'string' },
        gfe       => { type => 'string' },
        term      => { type => 'string' },
        rank      => { type => 'integer' },
        version   => { type => 'string' },
        log       => { type => 'array',
            items => { type => 'string' }
        },
    },
};

1;