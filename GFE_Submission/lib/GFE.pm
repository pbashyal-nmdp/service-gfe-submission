#!/usr/bin/env perl
=head1 NAME
 
    GFE.pm

=head1 SYNOPSIS

    Perl module for converting HLA, KIR and ABO sequences
    into gene feature enumeration (GFE) typings.

=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

=head1 DESCRIPTION


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

=head1 VERSIONS
    
    Version         Description                 Date


=head1 TODO
    
    - Add tests for the structures of known genes
    - Add DOM testing
    - Add more tests for classII
    - Add caching of sequences
    - Get aligned % from fasta2gfe to output in getGfeHmlNextflow

=head1 SUBROUTINES

=cut
package GFE;
use strict;
use warnings;
use REST::Client;
use Math::Round;
use FindBin;
use JSON;
use Moose;

use POSIX qw(strftime);
use Log::Log4perl;
use Data::Dumper;

use GFE::Structures;
use GFE::Annotate;
use GFE::Client;

our $VERSION = '1.0.7';

has 'structures' => (
    is => 'ro',
    isa => 'GFE::Structures',
    required => 1
);

has 'annotate' => (
    is => 'rw',
    isa => 'GFE::Annotate',
    required => 1
);

has 'client' => (
    is => 'rw',
    isa => 'GFE::Client',
    required => 1
);

has 'version' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has 'logfile' => (
    is => 'rw',
    isa => 'Str',
    clearer   => 'clear_logfile',
    predicate => 'has_logfile'
);

has 'return_structure' => (
    is => 'rw',
    isa => 'Bool'
);


has 'fileTypes' =>(
  is  => 'rw',
  required => 1
);

has 'verbose' => (
    is => 'rw',
    isa => 'Bool'
);

has 'delete_logs' => (
    is => 'rw',
    isa => 'Bool'
);


=head2 getGfe

    Title:     getGfe

    Args:      Locus, Sequence

    Function:  Converts HLA and KIR sequence into GFE

    Returns:   Hashref with GFE, aligned %, logs (optional),
               structure of sequence and package version. If
               errors occur then a hashref of Error type will
               be returned. Refer to the swagger definitions
               for Gfe and Error for more detail.

    Usage:     my $rh_gfe = $o_gfe->getGfe("HLA-A",$s_seq);
               my $s_gfe  = $$rh_gfe{gfe};

=cut
sub getGfe{

    my($self,$s_locus,$s_seq) = @_;

    my @a_gfe;
    my %h_seq;
    my @a_blank;
    my %h_accesion;
    my @a_structure;
    my %h_alignment;
    my $n_aligned_seq;
   
    $self->startLogfile();
    my $s_logfile = $self->logfile;

    my $logger       = Log::Log4perl->get_logger();
    my $o_annotate   = $self->annotate;
    my $o_client     = $self->client;
    my $o_structures = $self->structures;

    # Return an error if the sequence is not defined
    my $rh_check_seq = $self->checkSeq($s_seq,$s_locus);
    return $rh_check_seq if(defined $rh_check_seq);

    # Return an error if the locus is not valid
    my $rh_check_loc = $self->checkLoc($s_locus);
    return $rh_check_loc if(defined $rh_check_loc);

    # Get full gene accession number
    my $n_fullgene   = $o_client->getAccesion($s_locus,"gene",1,uc $s_seq);
    my $rh_fullgene  =  {
                      term      => "gene",                  
                      rank      => 1,
                      accession => $n_fullgene,
                      sequence  => uc $s_seq
                    };

    # Make fasta file from sequence
    my $s_fasta_file = $o_annotate->makeFasta($s_locus,$s_seq);

    # Return an error if the fasta file is not valid
    my $rh_file_check = $self->checkFile($s_fasta_file);
    return $rh_file_check if(defined $rh_file_check);

    # Running java -jar hap1.0.jar -g locus -i fasta_file
    my $b_exit_status = $o_annotate->align();

    # Check the exit status of the annotation pipeline
    my $rh_check_exit = $self->checkExitStatus($b_exit_status,"sequence",$s_seq);
    return $rh_check_exit if(defined $rh_check_exit);

    # Get generated alignment file 
    my $s_aligned_file = $o_annotate->alignment_file();

    # Return an error if the alignment file is not valid
    my $rh_alignment_check = $self->checkAlignmentFile();
    return $rh_alignment_check if(defined $rh_alignment_check);

    # Use the alignment results to submit to the GFE service
    open(my $fh_aligned,"<",$s_aligned_file) or die "CANT OPEN FILE $! $0";
    while(<$fh_aligned>){
        chomp;
        tr/\r//d;
        my ($id, $allele, $anum, $term, $rank, $seq) = split /\,/;
        $term = "five_prime_UTR"  if $term =~ /Five_prime/i;
        $term = "three_prime_UTR" if $term =~ /Three_prime/i;
        $h_accesion{$term}{$rank} = $o_client->getAccesion($s_locus,$term,$rank,uc $seq);
        $h_seq{$term}{$rank}      = $seq;
        $n_aligned_seq           += length($seq) if !defined $h_alignment{$_};
        $h_alignment{$_}++;
    }
    close $fh_aligned;
    %h_alignment = ();

    # Delete alignment and fasta files
    $o_annotate->cleanup();

    # Check results
    my $rh_check_results = $self->checkResults(\%h_accesion,$s_aligned_file);
    return $rh_check_results if(defined $rh_check_results);

    # Create the GFE from the known locus structures
    foreach my $term_rank (@{$o_structures->getStruct($s_locus)}) {
        my ($term, $rank) = split /:/, $term_rank;
        $h_accesion{$term}{$rank} = defined $h_accesion{$term}{$rank} ? $h_accesion{$term}{$rank} : '0';
        $h_seq{$term}{$rank}      = defined $h_seq{$term}{$rank}      ? $h_seq{$term}{$rank} : '';
        push @a_structure, {
              term  => $term,                  
              rank  => $rank,
              accession => $h_accesion{$term}{$rank},
              sequence  => $h_seq{$term}{$rank}
        };
        push(@a_gfe, $h_accesion{$term}{$rank}); 
    }

    my $f_aligned = sprintf("%.3f",$n_aligned_seq / length($s_seq));
    if($f_aligned < $o_annotate->aligned_cutoff){
        $logger->error("Aligned sequence did not meet cutoff: ".$f_aligned." < ".$o_annotate->aligned_cutoff);
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "Aligned sequence did not meet cutoff: ".$f_aligned." < ".$o_annotate->aligned_cutoff,
                locus    => $s_locus,
                type     => "Alignment",
                version  => $self->version,
                log      => $ra_log
            }
        };  
    }

    # Create GFE
    my $s_gfe        = join('w',$s_locus, join('-', @a_gfe));

    # Check to make sure the GFE is valid
    my $rh_check_gfe = $self->checkGfe($s_gfe,$s_locus);
    return $rh_check_gfe if(defined $rh_check_gfe);

    # Return logs if verbose flag is set
    if($self->verbose){
        my $ra_log = $self->returnLog();
        $self->return_structure
            ? return {gfe => $s_gfe, locus => $s_locus,  fullgene => $rh_fullgene, aligned => $f_aligned, structure => \@a_structure, version => $self->version,log => $ra_log }
            : return {gfe => $s_gfe, locus => $s_locus,  fullgene => $rh_fullgene, aligned => $f_aligned, version => $self->version, log => $ra_log };
    }else{
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        $self->return_structure
            ? return {gfe => $s_gfe, locus => $s_locus, fullgene => $rh_fullgene, aligned => $f_aligned, structure => \@a_structure, version => $self->version }
            : return {gfe => $s_gfe, locus => $s_locus, fullgene => $rh_fullgene, aligned => $f_aligned, version => $self->version };
    }
   
}


=head2 getGfeFasta

    Title:     getGfeFasta

    Args:      Locus, fasta file

    Function:  Converts fasta file with HLA and KIR sequence 
               into GFE with the header being the ID assocaited
               with the GFE.

    Returns:   Hashref with GFE, aligned %, logs (optional),
               structure of sequence and package version. If
               errors occur then a hashref of Error type will
               be returned. Refer to the swagger definitions
               for Gfe and Error for more detail.
               
    Usage:     my $rh_gfe  = $o_gfe->getGfeFasta("HLA-A",$s_fasta_file);
               foreach my $rh_sub (@{$$rh_gfe{subjects}}){
                   my $s_id = $$rh_sub{id};
                   foreach my $rh_typing_data (@{$$rh_sub{typingData}}){
                        my $s_locus  = $$rh_typing_data{locus};
                        my $s_gfe_gl = join("+",map{ $$_{gfe} } @{$$rh_typing_data{typing}});
                        print join(",",$s_id,$s_locus,$s_gfe_gl),"\n";
                   }
               }


=cut
sub getGfeFasta{

    my($self,$s_locus,$s_input_file) = @_;

    my %h_seq;
    my %h_accesion;
    my @a_subjects;

    $self->startLogfile();
    my $s_logfile = $self->logfile;

    my $logger       = Log::Log4perl->get_logger();
    my $o_annotate   = $self->annotate;
    my $o_client     = $self->client;
    my $o_structures = $self->structures;

    # Return an error if the fasta file is not valid
    my $rh_file_check = $self->checkFile($s_input_file);
    return $rh_file_check if(defined $rh_file_check);

    # Check to make sure the locus is valid
    my $rh_check_loc = $self->checkLoc($s_locus);
    return $rh_check_loc if(defined $rh_check_loc);

    # Pass input file to the annotation object
    $o_annotate->setFastaFile($s_locus,$s_input_file);

    # Running java -jar hap1.1.jar -g locus -i fasta_file
    my $b_exit_status = $o_annotate->align();

    # Check the exit status of the annotation pipeline
    my $rh_check_exit = $self->checkExitStatus($b_exit_status,"file",$s_input_file);
    return $rh_check_exit if(defined $rh_check_exit);

    # Get generated alignment file 
    my $s_aligned_file = $o_annotate->alignment_file();

    # Return an error if the alignment file is not valid
    my $rh_alignment_check = $self->checkAlignmentFile();
    return $rh_alignment_check if(defined $rh_alignment_check);

    # Use the alignment results to submit to the GFE service
    open(my $fh_aligned,"<",$s_aligned_file) or die "CANT OPEN FILE $! $0";
    while(<$fh_aligned>){
        chomp;
        tr/\r//d;
        my ($id, $allele, $anum, $term, $rank, $seq) = split /\,/;

        my $s_loc = $s_locus !~ /HLA-/ && $s_locus !~ /KIR/ ? "HLA-".$s_locus : $s_locus;
        if(!defined $o_annotate->order->{$s_loc}){
            $logger->warn("Locus not valid: ".$s_loc." ID: $id");
            next;
        }

        $term = "five_prime_UTR"  if $term =~ /Five_prime/i;
        $term = "three_prime_UTR" if $term =~ /Three_prime/i;

        $h_accesion{$id}{$term}{$rank} = $o_client->getAccesion($s_loc,$term,$rank,uc $seq);
        $h_seq{$id}{$term}{$rank}      = $seq;
    }
    close $fh_aligned;

    # Delete alignment and fasta files
    $o_annotate->cleanup();

    # Check results
    my $rh_check_results = $self->checkResults(\%h_accesion,$s_aligned_file);
    return $rh_check_results if(defined $rh_check_results);

    # Loop through each subject.. 
    foreach my $s_id (keys %h_seq){

        # Create the GFE from the known locus structures
        my @a_gfe;
        my @a_typing;
        my @a_structure;
        my @a_locus_typing;
        foreach my $term_rank (@{$o_structures->getStruct($s_locus)}) {
            my ($term, $rank) = split /:/, $term_rank;
            $h_accesion{$s_id}{$term}{$rank} = defined $h_accesion{$s_id}{$term}{$rank} ? $h_accesion{$s_id}{$term}{$rank} : '0';
            $h_seq{$s_id}{$term}{$rank}      = defined $h_seq{$s_id}{$term}{$rank}      ? $h_seq{$s_id}{$term}{$rank}      : '';
            push @a_structure, { 
                  term  => $term,                  
                  rank  => $rank,
                  accession => $h_accesion{$s_id}{$term}{$rank},
                  sequence  => $h_seq{$s_id}{$term}{$rank}
            };
            push(@a_gfe, $h_accesion{$s_id}{$term}{$rank}); 
        }

        # Create the GFE typing
        my $s_gfe = join('w',$s_locus, join('-', @a_gfe));

        # Check to make sure the GFE is valid
        my $rh_check_gfe = $self->checkGfe($s_gfe,$s_locus);
        return $rh_check_gfe if(defined $rh_check_gfe);


        if($self->return_structure){
            push(@a_typing,{ gfe => $s_gfe, structure => \@a_structure });
        }else{
            push(@a_typing,{ gfe => $s_gfe }); 
        }

        push(@a_locus_typing,{ locus => $s_locus, typing => \@a_typing });
        push(@a_subjects,{ id => $s_id, typingData => \@a_locus_typing }); 
  
    }

    # Return logs if verbose flag is set
    if($self->verbose){
        my $ra_log = $self->returnLog();
        return {subjects => \@a_subjects, version => $self->version,  log => $ra_log };
    }else{
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {subjects => \@a_subjects, version => $self->version };
    }
   
}


=head2 getGfeHml

    Title:     getGfeHml

    Args:      HML file

    Function:  Converts HML file with HLA and KIR sequence 
               into GFE with the subject ID being assocaited
               with the GFE.

    Returns:   Hashref with GFE, aligned %, logs (optional),
               structure of sequence and package version. If
               errors occur then a hashref of Error type will
               be returned. Refer to the swagger definitions
               for Gfe and Error for more detail.
               
    Usage:     my $rh_gfe  = $o_gfe->getGfeHml($s_hml_file);
               foreach my $rh_sub (@{$$rh_gfe{subjects}}){
                   my $s_id = $$rh_sub{id};
                   foreach my $rh_typing_data (@{$$rh_sub{typingData}}){
                        my $s_locus  = $$rh_typing_data{locus};
                        my $s_gfe_gl = join("+",map{ $$_{gfe} } @{$$rh_typing_data{typing}});
                        print join(",",$s_id,$s_locus,$s_gfe_gl),"\n";
                   }
               }


=cut
sub getGfeHml{

    my($self,$s_input_file) = @_;

    my %h_seq;
    my %h_imgthla;
    my %h_accesion;
    my @a_subjects;

    $self->startLogfile();
    my $s_logfile = $self->logfile;

    my $logger       = Log::Log4perl->get_logger();
    my $o_annotate   = $self->annotate;
    my $o_client     = $self->client;
    my $o_structures = $self->structures;

    # Return an error if the fasta file is not valid
    my $rh_file_check = $self->checkFile($s_input_file);
    return $rh_file_check if(defined $rh_file_check);

    # Pass input file to the annotation object
    $o_annotate->setHmlFile($s_input_file);

    # Running java -jar hap1.1.jar -g locus -i fasta_file
    my $b_exit_status = $o_annotate->alignHml();

    # Check the exit status of the annotation pipeline
    my $rh_check_exit = $self->checkExitStatus($b_exit_status,"file",$s_input_file);
    return $rh_check_exit if(defined $rh_check_exit);

    # Get generated alignment file and check to make sure it exists
    my $s_aligned_file = $o_annotate->alignment_file();

    # Return an error if the alignment file is not valid
    my $rh_alignment_check = $self->checkAlignmentFile();
    return $rh_alignment_check if(defined $rh_alignment_check);

    # Use the alignment results to submit to the GFE service
    open(my $fh_aligned,"<",$s_aligned_file) or die "CANT OPEN FILE $! $0";
    while(<$fh_aligned>){
        chomp;
        tr/\r//d;
        my ($id, $allele, $anum, $term, $rank, $seq) = split /\,/;
        $allele =~ /(HLA-\D+\d{0,1})\*/;my $s_locus = $1;
        
        my $s_loc = $s_locus !~ /HLA-/ && $s_locus !~ /KIR/ ? "HLA-".$s_locus : $s_locus;
        if(!defined $o_annotate->order->{$s_loc}){
            $logger->warn("Locus not valid: ".$s_loc." ID: $id");
            next;
        }

        $term = "five_prime_UTR"  if $term =~ /Five_prime/i;
        $term = "three_prime_UTR" if $term =~ /Three_prime/i;
        
        $h_accesion{$id}{$s_loc}{$anum}{$term}{$rank}  = $o_client->getAccesion($s_loc,$term,$rank,uc $seq);
        $h_seq{$id}{$s_loc}{$anum}{$term}{$rank}       = $seq;
        $h_imgthla{$id}{$s_loc}{$anum}                 = $allele;
    }
    close $fh_aligned;


    # Delete alignment and fasta files
    $o_annotate->cleanup();

    # Check results
    my $rh_check_results = $self->checkResults(\%h_accesion,$s_aligned_file);
    return $rh_check_results if(defined $rh_check_results);

    # Loop through each subject.. 
    foreach my $s_id (keys %h_seq){
        my @a_locus_typing;
        foreach my $s_locus (keys %{$h_seq{$s_id}}){
            my @a_typing;
            foreach my $anum (keys %{$h_seq{$s_id}{$s_locus}}){

                # Create the GFE from the known locus structures
                my @a_gfe;
                my @a_structure;
                foreach my $term_rank (@{$o_structures->getStruct($s_locus)}) {
                    my ($term, $rank) = split /:/, $term_rank;
                    $h_accesion{$s_id}{$s_locus}{$anum}{$term}{$rank} = defined $h_accesion{$s_id}{$s_locus}{$anum}{$term}{$rank} ? $h_accesion{$s_id}{$s_locus}{$anum}{$term}{$rank} : '0';
                    $h_seq{$s_id}{$s_locus}{$anum}{$term}{$rank}      = defined $h_seq{$s_id}{$s_locus}{$anum}{$term}{$rank}      ? $h_seq{$s_id}{$s_locus}{$anum}{$term}{$rank}      : '';
                    push @a_structure, {
                          term  => $term,                  
                          rank  => $rank,
                          accession => $h_accesion{$s_id}{$s_locus}{$anum}{$term}{$rank},
                          sequence  => $h_seq{$s_id}{$s_locus}{$anum}{$term}{$rank}
                    };
                    push(@a_gfe, $h_accesion{$s_id}{$s_locus}{$anum}{$term}{$rank}); 
                }

                # Create GFE
                my $s_gfe = join('w',$s_locus, join('-', @a_gfe));

                # Check to make sure the GFE is valid
                my $rh_check_gfe = $self->checkGfe($s_gfe,$s_locus);
                if(defined $rh_check_gfe){
                    $logger->error("Invalid GFE was generated: $s_gfe ID: $s_id Locus: $s_locus");
                    next;
                }

                if($self->return_structure){
                    push(@a_typing,{ imgthla => $h_imgthla{$s_id}{$s_locus}{$anum}, gfe => $s_gfe, structure => \@a_structure });
                }else{
                    push(@a_typing,{ imgthla => $h_imgthla{$s_id}{$s_locus}{$anum}, gfe => $s_gfe }); 
                }
            }
            push(@a_locus_typing,{locus => $s_locus, typing => \@a_typing });
        }
        $s_id = $s_id."-0";
        push(@a_subjects,{id => $s_id, typingData => \@a_locus_typing }); 
    }

    # Return logs if verbose flag is set
    if($self->verbose){
        my $ra_log = $self->returnLog();
        return {subjects => \@a_subjects, version => $self->version,  log => $ra_log };
    }else{
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {subjects => \@a_subjects, version => $self->version };
    }
   
}


=head2 getGfeHmlNextflow

    Title:     getGfeHmlNextflow

    Args:      HML file

    Function:  Converts HML file with HLA and KIR sequence 
               into GFE with the subject ID being assocaited
               with the GFE.

    Returns:   Hashref with GFE, aligned %, logs (optional),
               structure of sequence and package version. If
               errors occur then a hashref of Error type will
               be returned. Refer to the swagger definitions
               for Gfe and Error for more detail.
               
    Usage:     my $rh_gfe  = $o_gfe->getGfeHmlNextflow($s_hml_file);
               foreach my $rh_sub (@{$$rh_gfe{subjects}}){
                   my $s_id = $$rh_sub{id};
                   foreach my $rh_typing_data (@{$$rh_sub{typingData}}){
                        my $s_locus  = $$rh_typing_data{locus};
                        my $s_gfe_gl = join("+",map{ $$_{gfe} } @{$$rh_typing_data{typing}});
                        print join(",",$s_id,$s_locus,$s_gfe_gl),"\n";
                   }
               }


=cut
sub getGfeHmlNextflow{

    my($self,$s_input_file) = @_;

    my %h_seq;
    my %h_imgthla;
    my %h_accesion;
    my @a_subjects;

    $self->startLogfile();
    my $s_logfile = $self->logfile;

    my $logger       = Log::Log4perl->get_logger();
    my $o_annotate   = $self->annotate;
    my $o_client     = $self->client;
    my $o_structures = $self->structures;

    # Return an error if the fasta file is not valid
    my $rh_file_check = $self->checkFile($s_input_file);
    return $rh_file_check if(defined $rh_file_check);

    # Pass input file to the annotation object
    $o_annotate->setHmlFile($s_input_file);

    # run nextflow
    my $b_exit_status   = $o_annotate->alignNextflow();
    
    # Check the exit status of the annotation pipeline
    my $rh_check_exit = $self->checkNextflowStatus($b_exit_status);
    return $rh_check_exit if(defined $rh_check_exit);
    
    # Load nextflow output
    my %h_subjects;
    my $s_nextflow_file = $o_annotate->nextflow_file;
    open(my $fh_nextflow,"<",$s_nextflow_file) or die "CANT OPEN FILE $! $0";
    while(<$fh_nextflow>){
        chomp;
        my($s_subject_id,$s_typing,$s_locus,$s_gfe,$n_seq,$s_seq) = split(/,/,$_);
        $h_subjects{$s_subject_id}{$s_locus}{$s_gfe}++;
    }
    close $fh_nextflow;

    # If no results are observed..
    my $rh_check_results = $self->checkResults(\%h_subjects,$s_input_file);
    return $rh_check_results if(defined $rh_check_results);

    # Delete alignment and fasta files
    $o_annotate->cleanup();

    foreach my $s_subject_id (keys %h_subjects){
        my @a_locus_typing;
        foreach my $s_locus (keys %{$h_subjects{$s_subject_id}}){
            my @a_typing;
            foreach my $s_gfe (keys %{$h_subjects{$s_subject_id}{$s_locus}}){
                push(@a_typing,{  gfe => $s_gfe }); 
            }
            push(@a_locus_typing,{locus => $s_locus, typing => \@a_typing });
        }
        push(@a_subjects,{id => $s_subject_id."-0", typingData => \@a_locus_typing });
    }

    # Return logs if verbose flag is set
    if($self->verbose){
        my $ra_log = $self->returnLog();
        return {subjects => \@a_subjects, version => $self->version,  log => $ra_log };
    }else{
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {subjects => \@a_subjects, version => $self->version };
    }
}


=head2 getSequence

    Title:     getSequence

    Args:      Locus, gene feature enumeration (GFE)

    Function:  Converts GFE typing into the full sequence
               associated with the GFE.

    Returns:   DNA sequence
               
    Usage:     my $rh_seq  = $o_gfe->getSeq("HLA-A","");


=cut
sub getSequence{

    my($self,$s_locus,$s_gfe) = @_;

    my %h_seq;
    my %h_accesion;
    my @a_term_rank;
    my @a_structure;
    my @a_sequence;

    $self->startLogfile();
    my $s_logfile = $self->logfile;
    
    my $logger       = Log::Log4perl->get_logger();
    my $o_annotate   = $self->annotate;
    my $o_client     = $self->client;
    my $o_structures = $self->structures;

    # Check to make sure the GFE is valid
    my $rh_check_gfe = $self->checkGfe($s_gfe,$s_locus);
    return $rh_check_gfe if(defined $rh_check_gfe);

    # Return an error if the locus is not valid
    my $rh_check_loc = $self->checkLoc($s_locus);
    return $rh_check_loc if(defined $rh_check_loc);

    # Create the GFE from the known locus structures
    my $ra_term_rank = $o_structures->getStruct($s_locus);

    my(@a_gfe) = split(/-/,$s_gfe);
    for(1..$#a_gfe){
        my $term_rank = $$ra_term_rank[$_-1];

        if(!defined $term_rank || $term_rank !~ /\S/){
            $a_gfe[$_] = !defined $a_gfe[$_] ? '' : $a_gfe[$_];
            $logger->error("No term or rank defined $a_gfe[$_] $_");
            my $ra_log = $self->returnLog();
            return { 
                Error => { 
                    Message   => "No term or rank defined $a_gfe[$_] $_",
                    locus     => $s_locus,
                    type      => "Term_Rank",
                    gfe       => $s_gfe,
                    version   => $self->version,
                    log       => $ra_log
                }
            };
        }
        
        my ($s_term, $n_rank) = split /:/, $term_rank;
        my $n_accession = $a_gfe[$_];$n_accession =~ s/\D+w//;
        if(!defined $n_accession || $n_accession !~ /\S/ || $n_accession == 0){
            $logger->warn("Accession is not defined       - GFE:         $s_gfe");
            next;
        }

        # Get sequence from feature-service
        my $s_sequence = $o_client->getSequence($s_locus,$s_term,$n_rank,$n_accession);

        push @a_structure, {
              locus     => $s_locus, 
              term      => $s_term,                  
              rank      => $n_rank,
              accession => $n_accession,
              sequence  => $s_sequence
        };
        push(@a_sequence,$s_sequence);
    }
    my $s_sequence = join("",@a_sequence);

    my $ra_log = $self->returnLog();
    if($self->verbose){
        $self->return_structure
            ? return {sequence => $s_sequence, structure => \@a_structure, version => $self->version,log => $ra_log }
            : return {sequence => $s_sequence, version   => $self->version, log => $ra_log };
    }else{
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        $self->return_structure
            ? return {sequence => $s_sequence, structure => \@a_structure, version => $self->version }
            : return {sequence => $s_sequence, version   => $self->version };
    }
   
}

=head2 startLogfile

    Title:     startLogfile

    Args:      N/A

    Function:  Starts log4perl logfile with random ID

    Returns:   N/A
               
    Usage:     $o_gfe->startLogfile();
 

=cut
sub startLogfile{

    my $self = shift;

    my $s_logfile = $self->getLogfile();
    $self->logfile($s_logfile);

Log::Log4perl->init(\<<CONFIG);
log4perl.rootLogger = DEBUG, screen, file

log4perl.appender.screen = Log::Log4perl::Appender::Screen
log4perl.appender.screen.stderr = 1
log4perl.appender.screen.layout = PatternLayout
log4perl.appender.screen.layout.ConversionPattern = %d %p> %F{1}:%L %M - %m%n

log4perl.appender.file = Log::Log4perl::Appender::File
log4perl.appender.file.filename = $s_logfile
log4perl.appender.file.mode   = append
log4perl.appender.file.layout = PatternLayout
log4perl.appender.file.layout.ConversionPattern = %d %p> %F{1}:%L %M - %m%n
CONFIG


}

=head2 returnLog

    Title:     returnLog

    Args:      N/A

    Function:  Returns the log4perl log and deletes the 
               log file if it exists.

    Returns:   Array of text containing logs
               
    Usage:     my $ra_logs = $o_gfe->returnLog();
               print join("\n",@$ra_logs);

=cut
sub returnLog{

    my $self = shift;

    if($self->has_logfile && -e $self->logfile){
        my @a_log;
        my $s_logfile = $self->logfile;
        foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        $self->clear_logfile;
        return \@a_log;
    }

    return;

}

=head2 getLogfile

    Title:     getLogfile

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
    
=cut
sub getLogfile{
    my ( $self )  = @_;
    my $n_randid  = round(rand(10000));
    my $date      = strftime "%m-%d-%Y", localtime;
    my $s_logfile = "gfe.".$n_randid.".".$date.".log";
    return !-e $s_logfile ? $s_logfile : $self->getLogfile();
}


=head2 deleteOldFiles

    Title:     deleteOldFiles

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub deleteOldFiles{

    my ( $self )  = @_;

    my $date      = strftime "%m-%d-%Y", localtime;
    my @a_loci    = ("HLA_A", "HLA_B", "HLA_C"); 
    my $g_fasta   = $self->annotate->outdir."/*.fasta";
    my $g_csv1    = $self->annotate->directory."/*.csv";
    my $g_csv2    = $self->annotate->directory."/GFE/parsed-local/*.csv";

    foreach my $s_file (glob("$g_fasta $g_csv1 $g_csv2")){
        my @a_file = [$s_file, (stat $s_file)[9]];
        my $s_file_created = strftime("%m-%d-%Y", localtime $a_file[0]->[1]);
        if($s_file_created ne $date){
            system("rm $s_file");
        }
    }

    foreach my $s_loc  (@a_loci){
        my $s_clu_dir     = $self->annotate->directory."/output/clu/".$s_loc."/*.clu";
        my $s_exon_dir    = $self->annotate->directory."/output/exon/".$s_loc."/*.txt";
        my $s_fasta_dir   = $self->annotate->directory."/output/fasta/".$s_loc."/*.fasta";
        my $s_protein_dir = $self->annotate->directory."/output/protein/".$s_loc."/*.fasta";
        foreach my $s_file (glob("$s_clu_dir $s_exon_dir $s_fasta_dir $s_protein_dir")){
            my @a_file = [$s_file, (stat $s_file)[9]];
            my $s_file_created = strftime("%m-%d-%Y", localtime $a_file[0]->[1]);
            if($s_file_created ne $date){
                system("rm $s_file");
            }
        }
    }

}

=head2 checkNextflowStatus

    Title:     checkNextflowStatus

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkNextflowStatus{

    my ( $self, $b_exit_status ) = @_;

    my $logger     = Log::Log4perl->get_logger();
    my $o_annotate = $self->annotate;

    my $s_nextflow_file = $o_annotate->nextflow_file;
    if($b_exit_status != 0 && $b_exit_status != 911){
        $logger->error("Failed to run nextflow!");
        my $ra_log = $self->returnLog();
        return { 
            Error => { 
                Message  => "Failed to run Nextflow",
                type     => "Nextflow",
                file     => $s_nextflow_file,
                version  => $self->version,
                log      => $ra_log   
            }
        };
    }else{ $logger->info("Nextflow successfully executed") if $self->verbose; }

    if($b_exit_status == 911){
        $logger->error("Failed to create nextflow output!");
        my $ra_log = $self->returnLog();
        return { 
            Error => { 
                Message  => "Failed to create nextflow file",
                type     => "Nextflow",
                file     => $s_nextflow_file,
                version  => $self->version,
                log      => $ra_log
            }
        };
    }else{ $logger->info("Generated nextflow file: $s_nextflow_file") if $self->verbose; }

    return;
}

=head2 checkResults

    Title:     checkResults

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkResults{

    my( $self, $rh_results, $s_aligned_file ) = @_;

    my $logger     = Log::Log4perl->get_logger();
    my $o_annotate = $self->annotate;

    if(scalar (keys %$rh_results) == 0){
        $logger->error("Alignment ran but files are empty!");
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "Failed to generate fasta file",
                type     => "Alignment",
                file     => $s_aligned_file,
                version  => $self->version,
                log      => $ra_log
            }
        };
    }else{ $logger->info("Successfully loaded results") if $self->verbose; }

    return;
}

=head2 checkAlignedPercent

    Title:     checkAlignedPercent

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkAlignedPercent{

    my( $self, $f_aligned, $s_locus ) = @_;

    my $logger     = Log::Log4perl->get_logger();
    my $o_annotate = $self->annotate;

    if($f_aligned < $o_annotate->aligned_cutoff){
        $logger->error("Aligned sequence did not meet cutoff: ".$f_aligned." < ".$o_annotate->aligned_cutoff);
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "Aligned sequence did not meet cutoff: ".$f_aligned." < ".$o_annotate->aligned_cutoff,
                locus    => $s_locus,
                type     => "Alignment",
                version  => $self->version,
                log      => $ra_log
            }
        };  
    }

    return;

}

=head2 checkLoc

    Title:     checkLoc

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkLoc{

    my( $self, $s_locus ) = @_;

    my $logger     = Log::Log4perl->get_logger();
    my $o_annotate = $self->annotate;

    if(!defined $o_annotate->order->{$s_locus}){
        $logger->error("Locus not valid: ".$s_locus);
        my $ra_log = $self->returnLog();
        return { 
            Error => { 
                Message  => "Locus not valid",
                locus    => $s_locus,
                type     => "Locus",
                version  => $self->version,
                log      => $ra_log
            }
        };
    }

    return;
}

=head2 checkAlignmentFile

    Title:     checkAlignmentFile

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkAlignmentFile{

    my ( $self ) = @_;

    my $logger     = Log::Log4perl->get_logger();
    my $o_annotate = $self->annotate;

    my $s_aligned_file = $o_annotate->alignment_file();
    if(!-e $s_aligned_file || -z $s_aligned_file){
        $logger->error("Failed to create alignment file!");
        $o_annotate->cleanup();
        my $ra_log = $self->returnLog();
        return { 
            Error => { 
                Message  => "Failed to create alignment file!",
                type     => "Alignment",
                file     => $s_aligned_file,
                version  => $self->version,
                log      => $ra_log
            }
        };
    }else{ $logger->info("Generated alignment file: $s_aligned_file") if $self->verbose; }

    return;
}

=head2 checkGfe

    Title:     checkGfe

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkGfe{

    my ( $self, $s_gfe, $s_locus ) = @_;

    my $logger       = Log::Log4perl->get_logger();
    my $o_structures = $self->structures;

    # Return an error if the gfe is not valid
    if(!$o_structures->validGfe($s_locus,$s_gfe)){
        $s_locus = (!defined $s_locus || $s_locus !~ /\S/) ? "BLANK" : $s_locus;
        $s_gfe   = (!defined $s_gfe || $s_gfe !~ /\S/) ? '' : $s_gfe;
        $logger->error("GFE not valid: ".$s_gfe);
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "GFE not valid",
                locus    => $s_locus,
                type     => "GFE",
                gfe      => $s_gfe,
                version  => $self->version,
                log      => $ra_log
            }
        };
    }else{$logger->info("Generated GFE: ".$s_gfe) if $self->verbose;}

    return;

}

=head2 checkExitStatus

    Title:     checkExitStatus

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkExitStatus{

    my ( $self, $b_exit_status, $s_type, $s_data ) = @_;

    my $logger     = Log::Log4perl->get_logger();
    my $o_annotate = $self->annotate;

    if($b_exit_status != 0){
        $logger->error("Failed to run annotation!");
        $o_annotate->cleanup();
        my $ra_log = $self->returnLog();
        return { 
            Error => { 
                Message  => "Failed to run annotation",
                type     => "Annotation",
                $s_type  => $s_data,
                version  => $self->version,
                log      => $ra_log   
            }
        };
    }else{ $logger->info("Alignment ran successfully") if $self->verbose; }

    return;

}
=head2 checkSeq

    Title:     checkSeq

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
  
=cut
sub checkSeq{

    my( $self, $s_seq, $s_locus ) = @_;

    my $logger    = Log::Log4perl->get_logger();

    if(!defined $s_seq || $s_seq !~ /\S/){
        $logger->error("Sequence not defined");
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "Sequence not defined",
                locus    => $s_locus,
                type     => "Sequence",
                version  => $self->version,
                log      => $ra_log
            }
        };
    }

    # Sequence length is too small
    if(length($s_seq) < 30){
        $logger->error("Sequence length is too small");
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "Sequence length is too small",
                locus    => $s_locus,
                type     => "Sequence",
                version  => $self->version,
                log      => $ra_log
            }
        };
    }

    return;
}

=head2 checkFileType

    Title:     checkFileType

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile
  
=cut
sub checkFile{

    my ( $self, $s_input_file )  = @_;

    my $logger    = Log::Log4perl->get_logger();
    my $s_logfile = $self->logfile;

    # Check to make sure the file exists
    if(!defined $s_input_file || -z $s_input_file || !-e $s_input_file){
        $s_input_file = !defined $s_input_file ? '' : $s_input_file;
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "Input file not defined",
                file     => $s_input_file,
                type     => "File",
                version  => $self->version,
                log      => $ra_log
            }
        };
    }

    # Check to make sure the file type is supported
    my $s_file = (split(/\//,$s_input_file))[  scalar( @{[ $s_input_file=~/\//gi ]} ) ];
    my $s_suf  = (split(/\./,$s_file))[ scalar( @{[ $s_file=~/\./gi ]} )];
    if(!defined $self->fileTypes->{lc $s_suf}){
        my $ra_log = $self->returnLog();
        return {
            Error => { 
                Message  => "Input file type not valid! - $s_suf",
                type     => "File",
                file     => $s_input_file,
                version  => $self->version,
                log      => $ra_log
            }
        };
    }else{ $logger->info("File is valid") if $self->verbose; }

    # check that file is valid for it's particular type
    if($self->fileTypes->{lc $s_suf}->($s_file)){
        my $ra_log = $self->returnLog();
        return { 
            Error => { 
                Message  => "$s_file file is invalid for $s_suf type",
                type     => "File",
                file     => $s_file,
                version  => $self->version,
                log      => $ra_log    
            }
        };
    }else{ $logger->info("File is valid for $s_suf type") if $self->verbose; }

    return;
}

=head2 checkHml

    Title:     checkHml

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile    

=cut
sub checkHml{
    my ( $s_input_file )  = @_;

    # my $logger      = Log::Log4perl->get_logger();
    # my $s_cmd       = "ngs-validate-hml -i $s_input_file";
    # my $exit_value  = system($s_cmd);

    # if($exit_value != 0){
    #     $logger->error("system $s_cmd failed: $?");
    #     return 1;
    # }

    return 0;
}


=head2 checkFasta

    Title:     checkFasta

    Args:      N/A

    Function:  Returns logfile name with random ID that
               does not currently exists.

    Returns:   Logfile name
               
    Usage:     see startLogfile      

=cut
sub checkFasta{
    my ( $s_input_file )  = @_;
    return 0;
}




=head2 BUILDARGS

    Builds the GFE object with deafult 

=cut
around BUILDARGS=>sub
{
    my $orig=shift;
    my $class=shift;
    my $args=shift;

    my %h_filecheck = (
        "hml"   => \&checkHml,
        "fasta" => \&checkFasta,
        "fas"   => \&checkFasta,
        "fa"    => \&checkFasta
    );

    $args->{verbose}          = 0;
    $args->{delete_logs}      = 1;
    $args->{return_structure} = 1;
    $args->{annotate}         = GFE::Annotate->new();
    $args->{structures}       = GFE::Structures->new();
    $args->{client}           = GFE::Client->new();
    $args->{fileTypes}        = \%h_filecheck;
    $args->{version}          = $VERSION;

    return $class->$orig($args);
};



__PACKAGE__->meta->make_immutable;




1;