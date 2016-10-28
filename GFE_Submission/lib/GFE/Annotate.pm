#!/usr/bin/env perl
=head1 NAME
 

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
package GFE::Annotate;
use strict;
use warnings;
use Math::Round;
use Data::Dumper;
use POSIX qw(strftime);
use FindBin;
use Moose;

has 'directory' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'outdir' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'fileid' => (
    is => 'rw',
    isa => 'Int',
    predicate => 'has_fileid',
);

has 'locus' => (
    is => 'rw',
    isa => 'Str',
    clearer   => 'clear_locus',
    predicate => 'has_locus',
);

has 'fasta' => (
    is => 'rw',
    isa => 'Str',
    clearer   => 'clear_fasta',
    predicate => 'has_fasta',
);

has 'ids' =>(
  isa => 'HashRef[Int]',
  is  => 'rw',
  required => 1
);

has 'order' =>(
  isa => 'HashRef[Str]',
  is  => 'rw',
  required => 1
);

=head2 makeFasta

    Title:     makeFasta
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub makeFasta{

  my($self,$s_locus,$s_seq) = @_;
  $self->locus($s_locus);
  $self->fileid($self->getId());

  # Making fasta files to pass to hap1.jar
  open(my $fh_fasta,">",$self->fasta) or die "CANT OPEN FILE $! $0";
  print $fh_fasta ">$s_locus 1\n";
  print $fh_fasta $s_seq."\n";
  print $fh_fasta ">$s_locus 2\n";
  print $fh_fasta $s_seq."\n";
  close $fh_fasta;

}


=head2 alignment_fh

    Title:     alignment_fh
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub alignment_fh{
  my ( $self )       = @_;
  my $s_loc = $self->locus;
  $s_loc =~ s/HLA-//g;
  my $s_aligned_file = $self->directory."/GFE/parsed-local/".$self->fileid."HLA_".$s_loc."_reformat.csv";
  open(my $fh_align,"<",$s_aligned_file) or die "CANT OPEN FILE $! $0";
  return $fh_align;
}

=head2 align

    Title:     align
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub align{

  my ( $self )       = @_;
  my $s_locus      = $self->locus;
  my $s_fasta_file = $self->fasta;
  my $s_loc = $s_locus !~ /HLA-/ ? "HLA-".$s_locus : $s_locus;
  my $s_hap1_cmd = "java -jar ".$self->directory."/hap1.0.jar";
  my @args = ($s_hap1_cmd, " -g ".$self->order->{$s_loc}, " -i $s_fasta_file");

  my $exit_value = system(join("",@args));

  if($exit_value != 0){
    print STDERR "system @args failed: $?\n";
  }
  
  return $exit_value;
}

=head2 getId

    Title:     getId
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub getId{

  my ( $self )       = @_;
  my $n_randid     = round(rand(1000));
  my $s_fasta_file = $self->outdir."/".$n_randid.".gfe.fasta";

  if(defined $self->ids->{$n_randid} && !-e $s_fasta_file){
    return $self->getId();
  }else{
    $self->ids->{$n_randid}++;
    $self->fasta($s_fasta_file);
    return $n_randid;
  }

}

=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
  my $orig=shift;
  my $class=shift;
  my $args=shift; #other arguments passed in (if any).

  my %h_loci_order = (
    "HLA-A" => 0,
    "HLA-B" => 1,
    "HLA-C" => 2,
    "HLA-DRB1" => 3,
    "HLA-DPB1" => 4,
    "HLA-DQB1" => 5
  );

  my $s_hap1_dir=`which hap1.0.jar`;chomp($s_hap1_dir);
  $s_hap1_dir =~ s/hap1\.0\.jar//;
  $s_hap1_dir =~ s/\/$//;

  my $working      = "$FindBin::Bin/..";
  $working         = $working =~ /GFE_Submission/ ? $working =~ s/gfe_submission/GFE_Submission/ : $working;
  my $outdir       = $working."/public/downloads";

  my %h_ids = ( 0 => 1 );

  $args->{outdir}=$outdir;
  $args->{directory}=$s_hap1_dir;
  $args->{order}=\%h_loci_order;
  $args->{ids}=\%h_ids;
  return $class->$orig($args);
};



__PACKAGE__->meta->make_immutable;

1;