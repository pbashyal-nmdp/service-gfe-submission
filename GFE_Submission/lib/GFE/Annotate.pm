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
use Log::Log4perl;
use FindBin;
use Moose;
use Cwd;
    

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

  my $logger = Log::Log4perl->get_logger();
  $self->locus($s_locus);
  $self->fileid($self->getId());

  # Making fasta files to pass to hap1.jar
  open(my $fh_fasta,">",$self->fasta) or die $logger->error("CANT OPEN FILE $! $0");

  # ** clustalo requires there to be at least 2 sequences ** #
  print $fh_fasta ">$s_locus 1\n";
  print $fh_fasta $s_seq."\n";
  print $fh_fasta ">$s_locus 2\n";
  print $fh_fasta $s_seq."\n";
  close $fh_fasta;

  return $self->fasta;
}


=head2 alignment_fh

    Title:     alignment_fh
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub alignment_file{
  my ( $self )       = @_;
  my $s_loc = $self->locus;
  $s_loc =~ s/HLA-//g;
  my $s_aligned_file = $self->directory."/GFE/parsed-local/".$self->fileid."HLA_".$s_loc."_reformat.csv";
  return $s_aligned_file;
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

  my $logger       = Log::Log4perl->get_logger();
  my $s_locus      = $self->locus;
  my $s_fasta_file = $self->fasta;
  my $s_loc = $s_locus !~ /HLA-/ ? "HLA-".$s_locus : $s_locus;
  my $s_hap1_cmd = "java -jar ".$self->directory."/hap1.0.jar";
  my @args = ($s_hap1_cmd, " -g ".$self->order->{$s_loc}, " -i $s_fasta_file");

  print STDERR "CMD: ".join("",@args)."\n";

  my $exit_value = system(join("",@args));

  if($exit_value != 0){
    $logger->error("system @args failed: $?");
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

=head2 cleanup

    Title:     cleanup
    Usage:     deletes files after finished executing
    Function:  
    Returns:  
    Args:      

=cut
sub cleanup{

  my ( $self )       = @_;


}

=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
  my $orig=shift;
  my $class=shift;
  my $args=shift; #other arguments passed in (if any).

  my %h_loci_order = (
    "HLA-A"    => 0,
    "HLA-B"    => 1,
    "HLA-C"    => 2,
    "HLA-DRB1" => 3,
    "HLA-DPB1" => 4,
    "HLA-DQB1" => 5
  );

  my $s_hap1     =`which hap1.0.jar`;chomp($s_hap1);
  my $s_clustalo =`which clustalo`;chomp($s_clustalo);

  my $s_hap1_dir = $s_hap1;
  $s_hap1_dir    =~ s/hap1\.0\.jar//;
  $s_hap1_dir    =~ s/\/$//;

  my $working      = getcwd;
  my $outdir       = $working."/public/downloads";
  my $s_path       = `echo \$PATH`;chomp($s_path);

  # Die if the require programs aren't installed
  die "hap1.0.jar is not installed!\n hap1.jar == $s_hap1 \n PATH == $s_path"
    if(!defined $s_hap1 || !-x $s_hap1);

  die "clustalo is not installed!\n" 
    if(!defined $s_clustalo || !-x $s_clustalo);

  die "Ouput directory doesn't exists! $outdir \n" 
    if(!-d $outdir);

  die "Working directory doesn't exists! $working \n" 
    if(!-d $working);

  my %h_ids = ( 0 => 1 );
  $args->{outdir}    = $outdir;
  $args->{directory} = $s_hap1_dir;
  $args->{order}     = \%h_loci_order;
  $args->{ids}       = \%h_ids;
  return $class->$orig($args);
};



__PACKAGE__->meta->make_immutable;

1;