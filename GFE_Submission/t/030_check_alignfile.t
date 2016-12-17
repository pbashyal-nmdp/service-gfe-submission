=head1 NAME
 
   030_check_alignfile.t

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
use Test::More tests => 12;
use strict;
use warnings;

use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;

# Get working directory
my $pwd          = `pwd`;chomp($pwd);

## checkAlignmentFile valid
my $s_alignment_valid = $pwd."/t/resources/alignmentValid.csv";
my $o_annotate = GFE::Annotate->new();
$o_annotate->alignment($s_alignment_valid);
my $o_gfe_aln = GFE->new();
$o_gfe_aln->annotate($o_annotate);
my $rh_align_status = $o_gfe_aln->checkAlignmentFile();
ok(!defined $$rh_align_status{Error},"checkAlignmentFile works with ".$s_alignment_valid);
my $ra_aln_logs = $o_gfe_aln->returnLog();
ok(scalar @{$ra_aln_logs} > 0,"returnLog works with checkAlignmentFile with ".$s_alignment_valid);


# checkAlignmentFile blank
my $s_alignment_invalid1 = $pwd."/t/resources/alignmentBlank.csv";
my $o_annotate2 = GFE::Annotate->new();
$o_annotate2->alignment($s_alignment_invalid1);
my $o_gfe_aln2 = GFE->new();
$o_gfe_aln2->startLogfile();
$o_gfe_aln2->annotate($o_annotate2);
my $rh_align_status2 = $o_gfe_aln2->checkAlignmentFile();
my $ra_aln_logs2     = defined $$rh_align_status2{Error}{log} ? $$rh_align_status2{Error}{log} : '';
ok(defined $$rh_align_status2{Error},"checkAlignmentFile works with ".$s_alignment_invalid1);
ok(defined $$rh_align_status2{Error}{type},"checkAlignmentFile type defined with ".$s_alignment_invalid1);
ok($$rh_align_status2{Error}{type} eq "Alignment","checkAlignmentFile type equals Alignment with ".$s_alignment_invalid1);
ok(defined $ra_aln_logs2,"Error logs defined for checkAlignmentFile with ".$s_alignment_invalid1);
ok(scalar @{$ra_aln_logs2} > 0,"Error logs for checkAlignmentFile returned with ".$s_alignment_invalid1);


# checkAlignmentFile undef
my $s_alignment_undef = "alignmentUndef.csv";
my $o_annotate3 = GFE::Annotate->new();
$o_annotate3->alignment($s_alignment_undef);
my $o_gfe_aln3 = GFE->new();
$o_gfe_aln3->startLogfile();
$o_gfe_aln3->annotate($o_annotate3);
my $rh_align_status3 = $o_gfe_aln3->checkAlignmentFile();
my $ra_aln_logs3  = defined $$rh_align_status3{Error}{log} ? $$rh_align_status3{Error}{log} : '';
ok(defined $$rh_align_status3{Error},"checkAlignmentFile works with ".$s_alignment_undef);
ok(defined $$rh_align_status3{Error}{type},"checkAlignmentFile type defined with ".$s_alignment_undef);
ok($$rh_align_status3{Error}{type} eq "Alignment","checkAlignmentFile type equals Alignment with ".$s_alignment_undef);
ok(defined $ra_aln_logs3,"Error logs defined for checkAlignmentFile with ".$s_alignment_undef);
ok(scalar @{$ra_aln_logs3} > 0,"Error logs for checkAlignmentFile returned with ".$s_alignment_undef);



