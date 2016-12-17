#!/usr/bin/env perl
=head1 NAME
 
Structures

=head1 SYNOPSIS


=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

=head1 DESCRIPTION



=head1 CAVEATS
	

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
	
    Version    		Description             	Date


=head1 TODO
	

=head1 SUBROUTINES

=cut
package GFE::Structures;
use strict;
use warnings;
use FindBin;
use Moose;

use Log::Log4perl;

has 'hla' => (
    isa=>'HashRef[ArrayRef[Str]]',
    is=>'ro',
    required => 1
);

has 'gfe_length' => (
    isa=>'HashRef[Str]',
    is=>'ro',
    required => 1
);


=head2 getStruct


=cut
sub getStruct{
  my($self,$s_locus) = @_;
  return $self->{hla}->{$s_locus};
}

=head2 validGfe


=cut
sub validGfe{
  my($self,$s_loc,$s_gfe) = @_;

  return 0 if !defined $s_gfe;

  my $logger  = Log::Log4perl->get_logger();
  my $n = $s_gfe =~ /KIR/ ? (scalar split(/-/,$s_gfe)) : (scalar split(/-/,$s_gfe)) - 1;
  return 0 if $self->{gfe_length}->{$s_loc} != $n;
  
  my $s_invalid_gfe = $s_loc."w".join("-",map(0,(1..$self->{gfe_length}->{$s_loc})));
  return 0 if $s_gfe eq $s_invalid_gfe;

  return 1;
}


=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
  my $orig=shift;
  my $class=shift;
  my $args=shift; #other arguments passed in (if any).

  my %config_hash;
  my @a_loci = ("HLA-A", "HLA-B", "HLA-C","HLA-DPB1","HLA-DQB1","HLA-DRB1","KIR3DL2"); 
  # load structures
  foreach my $s_locus (@a_loci) {
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

  my %h_gfe_l;
  foreach my $s_loc (@a_loci){
    $h_gfe_l{$s_loc} = scalar @{$config_hash{$s_loc}};
  }

  $args->{hla}=\%config_hash;
  $args->{gfe_length}=\%h_gfe_l;

  return $class->$orig($args);
};




no Moose;
__PACKAGE__->meta->make_immutable;

1;