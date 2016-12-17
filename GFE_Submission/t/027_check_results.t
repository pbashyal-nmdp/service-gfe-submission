=head1 NAME
 
   027_check_results.t

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
use Test::More tests => 7;
use strict;
use warnings;

use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;


my $pwd          = `pwd`;chomp($pwd);

## checkResults valid
my %h_valid_results = (1 => "A",2 => "B",3 => "C");
my $s_blank_file    = "ValidFile.tmp";
my $o_gfe_r  = GFE->new();
my $rh_results_status1 = $o_gfe_r->checkResults(\%h_valid_results,$s_blank_file);
ok(!defined $$rh_results_status1{Error},"checkResults works with valid hash");
my $ra_blank_logs2 = $o_gfe_r->returnLog();
ok(!defined $ra_blank_logs2,"returnLog works with checkResults works with valid hash");

## checkResults invalid
my %h_invalid_results = ();
my $s_blank_file2    = "InvalidFile.tmp";
my $o_gfe_r2  = GFE->new();
$o_gfe_r2->startLogfile();
my $rh_results_status2 = $o_gfe_r2->checkResults(\%h_invalid_results,$s_blank_file2);
my $ra_logs3           = defined $$rh_results_status2{Error}{log} ? $$rh_results_status2{Error}{log} : '';
ok(defined $$rh_results_status2{Error},"checkResults works with invalid hash");
ok(defined $$rh_results_status2{Error}{type},"checkResults type defined with invalid hash");
ok($$rh_results_status2{Error}{type} eq "Alignment","checkResults type equals Alignment with invalid hash");
ok(defined $ra_logs3,"Error logs defined for checkResults with invalid hash");
ok(scalar @{$ra_logs3} > 0,"Error logs for checkResults returned with invalid hash");






