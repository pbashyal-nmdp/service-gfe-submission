=head1 NAME
 
   023_gfe_file.t

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

=cut
use Test::More tests => 5;
use strict;
use warnings;

use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;

my $pwd          = `pwd`;chomp($pwd);
my $s_fasta      = $pwd."/t/resources/fastatest1.fasta";
my $o_gfe        = GFE->new();
my $rh_fasta     = $o_gfe->checkFile($s_fasta);
ok(!defined $$rh_fasta{Error},"fasta file valid");

my $s_hml        = $pwd."/t/resources/hmltest1.HML";
my $rh_hml       = $o_gfe->checkFile($s_hml);
ok(!defined $$rh_hml{Error},"HML file valid");

my $o_gfe_c           = GFE->new();
my $rh_fasta_invalid  = $o_gfe_c->checkFile("ASDFS");
$o_gfe_c->startLogfile();
ok(defined $$rh_fasta_invalid{Error},"fasta file invalid");
ok(defined $$rh_fasta_invalid{Error}{type},"rh_seq typed defined defined");
ok($$rh_fasta_invalid{Error}{type} eq "File","r_invalid_gfe->{content}->{type} eq GFE");











