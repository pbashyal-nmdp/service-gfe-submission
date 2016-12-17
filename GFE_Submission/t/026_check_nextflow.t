=head1 NAME
 
   009_gfe_get.t

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
use Test::More tests => 14;
use strict;
use warnings;

use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;


## checkNextflowStatus valid
my $o_gfe_n  = GFE->new();
my $rh_flow_status1 = $o_gfe_n->checkNextflowStatus(0);
ok(!defined $$rh_flow_status1{Error},"checkNextflowStatus works for 0");
my $ra_blank_logs = $o_gfe_n->returnLog();
ok(!defined $ra_blank_logs,"returnLog works with checkNextflowStatus with exit status of 0");


# checkNextflowStatus valid
my $o_gfe_n2  = GFE->new();
$o_gfe_n2->startLogfile();
my $rh_flow_status2 = $o_gfe_n2->checkNextflowStatus(1);
my $ra_logs         = defined $$rh_flow_status2{Error}{log} ? $$rh_flow_status2{Error}{log} : '';
ok(defined $$rh_flow_status2{Error},"checkNextflowStatus caught 1 status");
ok(defined $$rh_flow_status2{Error}{type},"checkNextflowStatus 1 type defined");
ok($$rh_flow_status2{Error}{type} eq "Nextflow","checkNextflowStatus 1 type equals Nextflow");
ok($$rh_flow_status2{Error}{Message} eq "Failed to run Nextflow","checkNextflowStatus 1 message equals \"Failed to run Nextflow\"");
ok(defined $ra_logs,"Error logs defined for checkNextflowStatus 1");
ok(scalar @{$ra_logs} > 0,"Error logs for checkNextflowStatus 1 returned");


## checkNextflowStatus valid
my $o_gfe_n3  = GFE->new();
$o_gfe_n3->startLogfile();
my $rh_flow_status3 = $o_gfe_n3->checkNextflowStatus(911);
my $ra_logs2        = defined $$rh_flow_status3{Error}{log} ? $$rh_flow_status3{Error}{log} : '';
ok(defined $$rh_flow_status3{Error},"checkNextflowStatus caught 1 status");
ok(defined $$rh_flow_status3{Error}{type},"checkNextflowStatus 1 type defined");
ok($$rh_flow_status3{Error}{type} eq "Nextflow","checkNextflowStatus 1 type equals Nextflow");
ok($$rh_flow_status3{Error}{Message} eq "Failed to create nextflow file","checkNextflowStatus 1 message equals \"Failed to run Nextflow\"");
ok(defined $ra_logs2,"Error logs defined for checkNextflowStatus 911");
ok(scalar @{$ra_logs2} > 0,"Error logs for checkNextflowStatus 911 returned");


