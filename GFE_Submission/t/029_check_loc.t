=head1 NAME
 
   029_check_loc.t

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
use Test::More tests => 76;
use strict;
use warnings;

use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;

# Valid loci
my %h_valid_loci = (
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

#checkLoc invalid
my %h_invalid_loci = (
    "HLA-Z" => 0,
    "KIRWW" => 1,
    "A" => 2,
    "B" => 3,
    "MICA" => 4
);


#checkLoc valid
foreach my $s_valid_loc (keys %h_valid_loci){
    my $o_gfe_loc  = GFE->new();
    my $rh_loc_status = $o_gfe_loc->checkLoc($s_valid_loc);
    ok(!defined $$rh_loc_status{Error},"checkLoc works with ".$s_valid_loc);
    my $ra_blank_logs4 = $o_gfe_loc->returnLog();
    ok(!defined $ra_blank_logs4,"returnLog works with checkLoc with ".$s_valid_loc);
}

#checkLoc invalid
foreach my $s_invalid_loc (keys %h_invalid_loci){
    my $o_gfe_loc  = GFE->new();
    $o_gfe_loc->startLogfile();
    my $rh_loc_status = $o_gfe_loc->checkLoc($s_invalid_loc);
    ok(defined $$rh_loc_status{Error},"checkLoc works with ".$s_invalid_loc);
    my $ra_logs4        = defined $$rh_loc_status{Error}{log} ? $$rh_loc_status{Error}{log} : '';
    ok(defined $$rh_loc_status{Error},"checkLoc works with ".$s_invalid_loc);
    ok(defined $$rh_loc_status{Error}{type},"checkLoc type defined with ".$s_invalid_loc);
    ok($$rh_loc_status{Error}{type} eq "Locus","checkLoc type equals Locus with ".$s_invalid_loc);
    ok(defined $ra_logs4,"Error logs defined for checkLoc with ".$s_invalid_loc);
    ok(scalar @{$ra_logs4} > 0,"Error logs for checkLoc returned with ".$s_invalid_loc);
}







