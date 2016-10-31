#!/usr/bin/env perl
=head1 NAME
 
GFE

=head1 SYNOPSIS


=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

=head1 DESCRIPTION



=head1 CAVEATS
	

=head1 LICENSE

    Copyright (c) 2015 National Marrow Donor Program (NMDP)

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
	
    Version    		Description             	Date


=head1 TODO
	

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

has 'structures' => (
    is => 'ro',
    isa => 'GFE::Structures',
    required => 1
);

has 'annotate' => (
    is => 'ro',
    isa => 'GFE::Annotate',
    required => 1
);

has 'client' => (
    is => 'rw',
    isa => 'GFE::Client',
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
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub getGfe{

    my($self,$s_locus,$s_seq) = @_;

    my @a_log;
    my @a_gfe;
    my %h_seq;
    my %h_accesion;
    my @a_structure;

    my $s_logfile = $self->getLogfile();

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

    my $logger       = Log::Log4perl->get_logger();
    my $o_annotate   = $self->annotate;
    my $o_client     = $self->client;
    my $o_structures = $self->structures;

    # Return an error if the sequence is not defined
    if(!defined $s_seq || $s_seq !~ /\S/){
        $logger->error("Sequence not defined");
        foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {
            Error => { 
                Message  => "Sequence not defined",
                locus    => $s_locus,
                type     => "Sequence",
                log      => \@a_log
            }
        };
    }

    # Sequence length is too small
    if(length($s_seq) < 10){
        $logger->error("Sequence length is too small");
        foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {
            Error => { 
                Message  => "Sequence length is too small",
                locus    => $s_locus,
                type     => "Sequence",
                log      => \@a_log
            }
        };
    }


    # Return an error if the locus is not valid
    if(!defined $s_locus || $s_locus !~ /\S/ || !defined $o_annotate->order->{$s_locus}){
        $logger->error("Locus not valid: ".$s_locus);
        foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return { 
            Error => { 
                Message  => "Locus not valid",
                locus    => $s_locus,
                type     => "Locus",
                log      => \@a_log
            }
        };
    }

    # Make fasta file from sequence
    my $s_fasta_file = $o_annotate->makeFasta($s_locus,$s_seq);
    if(!-e $s_fasta_file){
        $logger->error("Failed to create fasta file!");
        $logger->error($s_fasta_file);
        foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return { 
            Error => { 
                Message  => "Failed to generate fasta file",
                locus    => $s_locus,
                sequence => $s_seq,
                type     => "Fasta",
                file     => $s_fasta_file,
                log      => \@a_log
            }
        };
    }else{ $logger->info("Generated fasta file: $s_fasta_file") if $self->verbose; }

    # Running java -jar hap1.0.jar -g locus -i fasta_file
    my $b_exit_status = $o_annotate->align();

    print STDERR "Exit status of alingnment $b_exit_status\n";
    if($b_exit_status != 0){
        $logger->error("Failed to run annotation!");
        $logger->error($s_locus);
        $logger->error($s_seq);
        foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return { 
            Error => { 
                Message  => "Failed to run annotation",
                type     => "Annotation",
                locus    => $s_locus,
                sequence => $s_seq,
                log      => \@a_log    
            }
        };
    }else{ $logger->info("Alignment ran successfully") if $self->verbose; }

    # Get generated alignment file and check to make sure it exists
    my $s_aligned_file = $o_annotate->alignment_file();
    if(!-e $s_aligned_file){
        $logger->error("Failed to create alignment file!");
        $logger->error($s_aligned_file);
        if($self->verbose){foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return { 
            Error => { 
                Message  => "Failed to create alignment file!",
                locus    => $s_locus,
                sequence => $s_seq,
                type     => "Alignment",
                file     => $s_aligned_file,
                log      => \@a_log
            }
        };
    }else{ $logger->info("Generated alignment file: $s_aligned_file") if $self->verbose; }

    # Use the alignment results to submit to the GFE service
    open(my $fh_aligned,"<",$s_aligned_file) or die "CANT OPEN FILE $! $0";
    while(<$fh_aligned>){
        chomp;
        tr/\r//d;
        my ($id, $allele, $anum, $term, $rank, $seq) = split /\,/;
        $term = "five_prime_UTR"  if $term eq "Five_prime-UTR";
        $term = "three_prime_UTR" if $term eq "Three_prime-UTR";
        my $s_loc = $s_locus !~ /HLA-/ ? "HLA-".$s_locus : $s_locus;
        $h_accesion{$term}{$rank} = $o_client->getAccesion($s_loc,$term,$rank,uc $seq);
        $h_seq{$term}{$rank}      = $seq;
    }
    close $fh_aligned;

    # If no results are observed..
    if((scalar (keys %h_seq) == 0) || (scalar (keys %h_accesion) == 0)){
        $logger->error("Alignment ran but files are empty!");
        if($self->verbose){foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {
            Error => { 
                Message  => "Failed to generate fasta file",
                locus    => $s_locus,
                sequence => $s_seq,
                type     => "Alignment",
                file     => $s_aligned_file,
                log      => \@a_log
            }
        };
    }else{ $logger->info("Successfully loaded alignment results") if $self->verbose; }

    # Create the GFE from the known locus structures
    foreach my $term_rank (@{$o_structures->getStruct($s_locus)}) {
        my ($term, $rank) = split /:/, $term_rank;
        $h_accesion{$term}{$rank} = defined $h_accesion{$term}{$rank} ? $h_accesion{$term}{$rank} : '0';
        $h_seq{$term}{$rank}      = defined $h_seq{$term}{$rank}      ? $h_seq{$term}{$rank} : '';
        push @a_structure, {
              locus => $s_locus, 
              term  => $term,                  
              rank  => $rank,
              accession => $h_accesion{$term}{$rank},
              sequence  => $h_seq{$term}{$rank}
        };
        push(@a_gfe, $h_accesion{$term}{$rank}); 
    }

    my $s_gfe = join('w',$s_locus, join('-', @a_gfe));
    if($s_gfe eq $s_locus."w1-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0"){
        $logger->error("Invalid GFE was generated");
        if($self->verbose){foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {
            Error => { 
                Message  => "Invalid GFE was generated",
                locus    => $s_locus,
                sequence => $s_seq,
                type     => "GFE",
                file     => $s_aligned_file,
                log      => \@a_log
            }
        };  
    }else{ $logger->info("Generated GFE: $s_gfe") if $self->verbose; }

   
    if($self->verbose){
        foreach(`cat $s_logfile`){ chomp;push(@a_log,$_);}
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {gfe => $s_gfe, structure => \@a_structure,log => \@a_log };
    }else{
        system("rm $s_logfile") if (-e $s_logfile && $self->delete_logs);
        return {gfe => $s_gfe, structure => \@a_structure };
    }
   
}

=head2 getId

    Title:     getId
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub getLogfile{
    my ( $self )  = @_;
    my $n_randid  = round(rand(10000));
    my $date      = strftime "%m-%d-%Y", localtime;
    my $s_logfile = "gfe.".$n_randid.".".$date.".log";
    return !-e $s_logfile ? $s_logfile : $self->getLogfile();
}


=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
    my $orig=shift;
    my $class=shift;
    my $args=shift;

    $args->{delete_logs} = 1;
    $args->{annotate}    = GFE::Annotate->new();
    $args->{structures}  = GFE::Structures->new();
    $args->{client}      = GFE::Client->new();

    return $class->$orig($args);
};



__PACKAGE__->meta->make_immutable;




1;