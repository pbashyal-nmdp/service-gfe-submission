=head1 NAME
 
   032_check_exit.t

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
use Test::More tests => 9;
use strict;
use warnings;

use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;


#checkExitStatus valid
my $o_gfe_exit = GFE->new();
my $rh_exit_status = $o_gfe_exit->checkExitStatus(0,"Test","Test");
ok(!defined $$rh_exit_status{Error},"checkExitStatus works with 0 exit status");
my $ra_exit_logs = $o_gfe_exit->returnLog();
ok(!defined $ra_exit_logs,"returnLog works with checkExitStatus with 0 exit status");

#checkExitStatus invalid
my $o_gfe_exit2 = GFE->new();
$o_gfe_exit2->startLogfile();
my $rh_exit_status2 = $o_gfe_exit2->checkExitStatus(1,"Test","Failed");
my $ra_exit_logs2   = defined $$rh_exit_status2{Error}{log} ? $$rh_exit_status2{Error}{log} : '';
ok(defined $$rh_exit_status2{Error},"checkExitStatus works with failed 1 exit status");
ok(defined $$rh_exit_status2{Error}{type},"checkExitStatus type defined with with failed 1 exit status");
ok($$rh_exit_status2{Error}{type} eq "Annotation","checkExitStatus type equals Annotation with with failed 1 exit status");
ok(defined $$rh_exit_status2{Error}{Test},"checkExitStatus Test defined with with failed 1 exit status");
ok($$rh_exit_status2{Error}{Test} eq "Failed","checkExitStatus Test equals Failed with with failed 1 exit status");
ok(defined $ra_exit_logs2,"Error logs defined for checkExitStatus with with failed 1 exit status");
ok(scalar @{$ra_exit_logs2} > 0,"Error logs for checkExitStatus returned with with failed 1 exit status");





