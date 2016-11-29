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
  
    Version       Description               Date


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
    
$| = 1;

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
    isa => 'Str',
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

has 'hml' => (
    is => 'rw',
    isa => 'Str',
    clearer   => 'clear_hml',
    predicate => 'has_hml',
);

has 'fastanf' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has 'hmlnf' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has 'nextflow_file' => (
    is => 'rw',
    isa => 'Str',
    clearer   => 'clear_nextflow',
    predicate => 'has_nextflow',
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

has 'aligned_cutoff' =>(
  isa => 'Num',
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

=head2 setFasta

    Title:     setFasta
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub setFastaFile{

  my($self,$s_locus,$s_input_file) = @_;

  my $logger = Log::Log4perl->get_logger();
  my $s_file = (split(/\//,$s_input_file))[  scalar( @{[ $s_input_file=~/\//gi ]} ) ];
  my $s_pref = (split(/\./,$s_file))[0];

  $self->fasta($s_input_file);
  $self->fileid($s_pref);
  $self->locus($s_locus);

  $logger->info("Input file: $s_input_file");

}


=head2 setHmlFile

    Title:     setFasta
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub setHmlFile{

  my($self,$s_hml_file) = @_;

  my $logger = Log::Log4perl->get_logger();
  my $s_file = (split(/\//,$s_hml_file))[  scalar( @{[ $s_hml_file=~/\//gi ]} ) ];
  my $s_pref = (split(/\./,$s_file))[0];

  $self->hml($s_hml_file);
  $self->fileid($s_pref);

  $logger->info("HML file: $s_hml_file");

}


=head2 alignment_file

    Title:     alignment_file
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub alignment_file{
  my ( $self )       = @_;

  my $logger         = Log::Log4perl->get_logger();
  my $s_aligned_file = $self->directory."/GFE/parsed-local/".$self->fileid."_reformat.csv";
  $logger->info("Alignment file: $s_aligned_file");

  return $s_aligned_file;
}


=head2 align

    Title:     align
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub alignHml{

  my ( $self )       = @_;

  my $logger       = Log::Log4perl->get_logger();
  my $s_hml_file   = $self->hml;

  my $s_hap1_cmd = "java -jar ".$self->directory."/hap1.1.jar";
  my @args = ($s_hap1_cmd, " -i $s_hml_file"," -o ".$self->directory."/GFE/parsed-local/");

  my $exit_value = system(join("",@args));

  if($exit_value != 0){
    $logger->error("system @args failed: $?");
  }

  return $exit_value;
}


=head2 alignNextflow

    Title:     alignNextflow
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub alignNextflow{

  my ( $self )       = @_;

  my $logger       = Log::Log4perl->get_logger();
  my $s_hml_file   = $self->hml;

  $self->fileid($self->getId());
  $self->nextflow_file($self->outdir."/".$self->fileid.".txt");
  my $s_nextflow_log = $self->fileid.".flow.log";
  my $s_flow_glob    = ".nextflow.lo*";
  my $s_flow_log     = ".nextflow.log";
  my $s_hap1_cmd     = "nextflow run ".$self->hmlnf;

  my @args = ($s_hap1_cmd, " --hml $s_hml_file"," --output ".$self->outdir," --name ".$self->fileid," > ".$s_nextflow_log);
  my $exit_value      = system(join("",@args));

  # Check if nextflow failed
  if($exit_value != 0){
    $logger->error("system @args failed: $?");
    foreach my $s_log_flow (`cat $s_nextflow_log`){
      chomp($s_log_flow);
      $logger->error($s_log_flow);
    }
  }else{
    if(defined $s_nextflow_log && -e $s_nextflow_log){
      foreach my $s_log_dir (`cat $s_nextflow_log | grep '/' | cut -f1 -d ' ' | sed 's/\\[//g' | cut -f1 -d '/'`){
        chomp($s_log_dir);
        my $s_work_dir = "work/".$s_log_dir;
        system("rm -rf $s_work_dir") if(-d $s_work_dir);
      }
    }
  }

  system("rm -rf $s_flow_glob") if(-e $s_flow_log);
  system("rm $s_nextflow_log")  if(-e $s_nextflow_log);

  return $exit_value;
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
  my $s_loc = $s_locus !~ /HLA-/ && $s_locus !~ /KIR/ ? "HLA-".$s_locus : $s_locus;
  my $s_hap1_cmd = "java -jar ".$self->directory."/hap1.1.jar";
  my @args = ($s_hap1_cmd, " -g ".$self->order->{$s_loc}, " -i $s_fasta_file"," -o ".$self->directory."/GFE/parsed-local/");

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
  my $n_randid     = round(rand(10000));
  my $s_fasta_file = $self->outdir."/".$n_randid.".fasta";

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

  my $s_nextflow     = $self->outdir."/".$self->fileid.".txt";
  my $s_fasta        = $self->fasta;
  my $s_aligned_file = $self->alignment_file();
  my $s_outhap1      = $self->directory."/".$self->fileid."_ann.csv";

  system("rm $s_fasta")        if($self->has_fasta && defined $s_fasta 
                                    && $s_fasta !~ /t\/resources/ && -e $s_fasta);
  system("rm $s_aligned_file") if(defined $s_aligned_file && -e $s_aligned_file);
  system("rm $s_nextflow")     if(defined $s_nextflow && -e $s_nextflow);
  system("rm $s_outhap1")      if(defined $s_outhap1 && -e $s_outhap1);
  system("rm -rf .nextflow")   if(-d ".nexflow");

  if($self->has_locus){
    my $s_loc = $self->locus;
    $s_loc =~ s/-/_/;
    my $alignment = $self->directory."/output/clu/".$s_loc."/".$self->fileid.".clu";
    system("rm $alignment")      if(defined $alignment && -e $alignment);
  }

  $self->clear_nextflow;
  $self->clear_hml;
  $self->clear_fasta;

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
    "HLA-DQB1" => 5,
    "PB-DRB1" => 6,
    "PB-DPB1" => 7,
    "PB-DQB1" => 8,
    "KIR3DP1" => 9,
    "KIR2DL4" => 10,
    "KIR2DL5A" => 11,
    "KIR2DL5B" => 12,
    "KIR2DS1" => 13,
    "KIR2DS2" => 14,
    "KIR2DS3" => 15,
    "KIR2DS4" => 16,
    "KIR2DS5" => 17,
    "KIR3DL3" => 18,
    "KIR3DL1" => 19,
    "KIR3DL2" => 20,
    "KIR2DP1" => 21,
    "KIR3DS1" => 22
  );

  my $s_hap1       =`which hap1.1.jar`;chomp($s_hap1);
  my $s_clustalo   =`which clustalo`;chomp($s_clustalo);
  my $s_hml_flow   = "$FindBin::Bin/../bin/hml.nf";
  my $s_fasta_flow = "$FindBin::Bin/../bin/fasta.nf";

  my $s_hap1_dir = $s_hap1;
  $s_hap1_dir    =~ s/hap1\.1\.jar//;
  $s_hap1_dir    =~ s/\/$//;

  my $working      = getcwd;
  my $outdir       = $working."/public/downloads";
  my $s_path       = `echo \$PATH`;chomp($s_path);

  # Die if the require programs aren't installed
  die "hap1.1.jar is not installed!\n hap1.1.jar == $s_hap1 \n PATH == $s_path"
    if(!defined $s_hap1 || !-x $s_hap1);

  die "clustalo is not installed!\n" 
    if(!defined $s_clustalo || !-x $s_clustalo);

  $outdir    = $working if(!-d $outdir);

  die "Working directory doesn't exists! $working \n" 
    if(!-d $working);

  my %h_ids = ( 0 => 1 );
  $args->{aligned_cutoff} = .5;
  $args->{hmlnf}          = $s_hml_flow;
  $args->{fastanf}        = $s_fasta_flow;
  $args->{outdir}         = $outdir;
  $args->{directory}      = $s_hap1_dir;
  $args->{order}          = \%h_loci_order;
  $args->{ids}            = \%h_ids;
  return $class->$orig($args);
};



__PACKAGE__->meta->make_immutable;

1;