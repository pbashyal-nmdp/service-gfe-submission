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
use FindBin;
use JSON;
use Moose;

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


=head2 getGfe

    Title:     getGfe
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub getGfe{

    my($self,$s_locus,$s_seq) = @_;

    my $o_annotate   = $self->annotate;
    my $o_client     = $self->client;
    my $o_structures = $self->structures;

    # Make fasta file from sequence
    my $s_fasta_file = $o_annotate->makeFasta($s_locus,$s_seq);

    # Running java -jar hap1.0.jar -g locus -i fasta_file
    my $b_exit_status = $o_annotate->align();
    if($b_exit_status != 0){ return { "Failed" => "Failed to annotate! $s_locus $s_seq!"}; }

    my %h_seq;
    my %h_accesion;
    my $fh_aligned = $o_annotate->alignment_fh();
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

    my @g;
    my @a_structure;
    foreach my $term_rank (@{$o_structures->getStruct($s_locus)}) {
        my ($term, $rank) = split /:/, $term_rank;
        $h_accesion{$term}{$rank} = defined $h_accesion{$term}{$rank} ? $h_accesion{$term}{$rank} : '0';
        $h_seq{$term}{$rank}      = defined $h_seq{$term}{$rank}      ? $h_seq{$term}{$rank} : '';
        my %h_a = ("term" => $term,"rank" => $rank,"accession" => $h_accesion{$term}{$rank}, "sequence" => $h_seq{$term}{$rank});
        push @a_structure, {
              locus => $s_locus, 
              term  => $term,                  
              rank  => $rank,
              accession => $h_accesion{$term}{$rank},
              sequence => $h_seq{$term}{$rank}
        };
        push(@g, $h_accesion{$term}{$rank}); 
    }

    return {gfe => join('w',$s_locus, join('-', @g)), structure => \@a_structure };
}





=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
  my $orig=shift;
  my $class=shift;
  my $args=shift; #other arguments passed in (if any).

  $args->{annotate}=GFE::Annotate->new();
  $args->{structures}=GFE::Structures->new();
  $args->{client}=GFE::Client->new();

  return $class->$orig($args);
};



__PACKAGE__->meta->make_immutable;




1;