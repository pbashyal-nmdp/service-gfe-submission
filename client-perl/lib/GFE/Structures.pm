#!/usr/bin/env perl
=head1 NAME
 
ARS_App - Service for doing ARS reduction
 
Version 1.0.0
VERSION 1231

=cut

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
package GFE::Structures;
use strict;
use warnings;
use FindBin;
use Moose;
 


has 'hla' => (
    isa=>'HashRef[ArrayRef[Str]]',
    is=>'rw',
    required => 1
);

=head2 getStruct


=cut
sub getStruct{
  my($self,$s_locus) = @_;
  $s_locus = $s_locus !~ /HLA-/ ? "HLA-".$s_locus : $s_locus;
  return $self->{hla}->{$s_locus};
}

=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
  my $orig=shift;
  my $class=shift;
  my $args=shift; #other arguments passed in (if any).

  my %config_hash;
  my @loci = ("HLA-A", "HLA-B", "HLA-C","HLA-DPB1","HLA-DQB1","HLA-DRB1"); 
  # load structures
  foreach my $s_locus (@loci) {
    my $s_loc = $s_locus;
    $s_loc =~ s/HLA-//g;
    my $structure_file = "$FindBin::Bin/../lib/files/$s_loc.structure";
    open(my $fh_struct,"<", $structure_file) or die "$!: $structure_file";
    while(<$fh_struct>) {
      chomp;
      my ($term, $rank) = split /\t/;
      push @{$config_hash{$s_locus}}, join ':', $term, $rank;
    }
    close $fh_struct;
  }

  $args->{hla}=\%config_hash;

  return $class->$orig($args);
};




no Moose;
__PACKAGE__->meta->make_immutable;

1;