=head1 NAME
 
   028_check_aligned.t

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
use Test::More tests => 21;
use strict;
use warnings;

use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;

#checkAlignedPercent valid
foreach my $per (.75,.95,1){
    my $o_gfe_p  = GFE->new();
    my $rh_percent_status = $o_gfe_p->checkAlignedPercent($per,"HLA-A");
    ok(!defined $$rh_percent_status{Error},"checkAlignedPercent works with ".$per." and HLA-A");
    my $ra_blank_logs3 = $o_gfe_p->returnLog();
    ok(!defined $ra_blank_logs3,"returnLog works with checkAlignedPercent with ".$per." and HLA-A");
}

#checkAlignedPercent invalid
foreach my $per (0,.25,.5){
    my $o_gfe_p  = GFE->new();
    $o_gfe_p->startLogfile();
    my $rh_percent_status = $o_gfe_p->checkAlignedPercent($per,"HLA-A");
    my $ra_logs4        = defined $$rh_percent_status{Error}{log} ? $$rh_percent_status{Error}{log} : '';
    ok(defined $$rh_percent_status{Error},"checkAlignedPercent works with ".$per." and HLA-A");
    ok(defined $$rh_percent_status{Error}{type},"checkAlignedPercent type defined with ".$per." and HLA-A");
    ok($$rh_percent_status{Error}{type} eq "Alignment","checkAlignedPercent type equals Alignment with ".$per." and HLA-A");
    ok(defined $ra_logs4,"Error logs defined for checkAlignedPercent with ".$per." and HLA-A");
    ok(scalar @{$ra_logs4} > 0,"Error logs for checkAlignedPercent returned with ".$per." and HLA-A");
}







