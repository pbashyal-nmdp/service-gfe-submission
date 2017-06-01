=head1 NAME
 
   031_check_gfe.t

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
use Test::More tests => 240;
use strict;
use warnings;
use Data::Dumper;
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;
use FindBin;


my %config_hash;
my @a_loci = ("HLA-A", "HLA-B", "HLA-C","HLA-DPB1","HLA-DQB1","HLA-DRB1","KIR3DL2","KIR3DL1","KIR2DS5","KIR2DL4","KIR2DL5A","KIR3DS1","KIR2DS2","KIR3DP1","KIR2DS4","KIR3DL3","KIR2DP1","KIR2DS1","KIR2DS3","KIR2DL5B"); 

# load structures
foreach my $s_locus (@a_loci) {
    my $s_loc = $s_locus;
    $s_loc =~ s/HLA-//g;
    my $structure_file = "$FindBin::Bin/../lib/files/$s_loc.structure";
    open(my $fh_struct,"<", $structure_file) or die "$!: $structure_file";
    while(<$fh_struct>) {
      chomp;
      my ($term, $rank) = split /\t/;
      push @{$config_hash{$s_locus}}, join ':', $term, $rank;
    }
    close $fh_struct;
}

my %h_gfe_size;
foreach my $s_loc (@a_loci){
    $h_gfe_size{$s_loc} = scalar @{$config_hash{$s_loc}};
}

my %h_valid_gfe;
my %h_invalid_gfe;
foreach my $s_loc (keys %h_gfe_size){
    my $s_valid_gfe   = $s_loc."w".join("-",map(1, (1..$h_gfe_size{$s_loc})));
    my $s_invalid_gfe = $s_loc."w".join("-",map(0, (1..$h_gfe_size{$s_loc})));
    $h_valid_gfe{$s_loc}   = $s_valid_gfe;
    $h_invalid_gfe{$s_loc} = $s_invalid_gfe;
}


#checkGfe valid
foreach my $s_loc (keys %h_valid_gfe){
    my $o_gfe_gfe = GFE->new();
    my $s_gfe = $h_valid_gfe{$s_loc};
    my $rh_gfe_status = $o_gfe_gfe->checkGfe($s_gfe,$s_loc);
    ok(!defined $$rh_gfe_status{Error},"checkGfe works with ".$s_gfe);
    my $ra_gfe_logs = $o_gfe_gfe->returnLog();
    ok(!defined $ra_gfe_logs,"returnLog works with checkGfe with ".$s_gfe);
}


#checkGfe invalid
foreach my $s_loc (keys %h_invalid_gfe){
    my $o_gfe_gfe = GFE->new();
    $o_gfe_gfe->startLogfile();
    my $s_gfe = $h_invalid_gfe{$s_loc};
    my $rh_gfe_status = $o_gfe_gfe->checkGfe($s_gfe,$s_loc);
    my $ra_gfe_logs   = defined $$rh_gfe_status{Error}{log} ? $$rh_gfe_status{Error}{log} : '';
    ok(defined $$rh_gfe_status{Error},"checkGfe works with ".$s_gfe);
    ok(defined $$rh_gfe_status{Error}{type},"checkGfe type defined with ".$s_gfe);
    ok($$rh_gfe_status{Error}{type} eq "GFE","checkGfe type equals GFE with ".$s_gfe);
    ok(defined $ra_gfe_logs,"Error logs defined for checkGfe with ".$s_gfe);
    ok(scalar @{$ra_gfe_logs} > 0,"Error logs for checkGfe returned with ".$s_gfe);

    my $o_gfe_gfe2 = GFE->new();
    $o_gfe_gfe2->startLogfile();
    my $s_gfe2 = $s_loc."w1-1-1";
    my $rh_gfe_status2 = $o_gfe_gfe2->checkGfe($s_gfe2,$s_loc);
    my $ra_gfe_logs2   = defined $$rh_gfe_status2{Error}{log} ? $$rh_gfe_status2{Error}{log} : '';
    ok(defined $$rh_gfe_status2{Error},"checkGfe works with ".$s_gfe2);
    ok(defined $$rh_gfe_status2{Error}{type},"checkGfe type defined with ".$s_gfe2);
    ok($$rh_gfe_status2{Error}{type} eq "GFE","checkGfe type equals GFE with ".$s_gfe2);
    ok(defined $ra_gfe_logs2,"Error logs defined for checkGfe with ".$s_gfe2);
    ok(scalar @{$ra_gfe_logs2} > 0,"Error logs for checkGfe returned with ".$s_gfe2);

}

