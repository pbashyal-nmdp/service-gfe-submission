=head1 NAME
 
   021_file_hml.t

=head1 SYNOPSIS


=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

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

=cut
use Test::More tests => 32;
use strict;
use warnings;
use Data::Dumper;
# the order is important
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;
use XML::DOM;

my $pwd        = `pwd`;chomp($pwd);
my $t_file     = $pwd."/t/resources/hmltest1.HML";

my %h_expected_gfe;
$h_expected_gfe{"1111111111"}{"HLA-A"} = "HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1+HLA-Aw1-7-10-41-18-56-6-21-2-8-11-2-9-2-4-1-1";
$h_expected_gfe{"1111111111"}{"HLA-B"} = "HLA-Bw10-12-17-128-36-145-27-20-2-10-26-1-1-1+HLA-Bw10-8-11-110-21-63-14-13-5-6-15-1-1-2";
$h_expected_gfe{"1111111111"}{"HLA-C"} = "HLA-Cw1-5-5-22-8-50-8-9-1-6-1-1-1-5-1-1-1+HLA-Cw23-7-10-51-10-85-13-15-8-7-8-3-7-3-6-1-1";
$h_expected_gfe{"222222222"}{"HLA-A"} = "HLA-Aw1-7-10-66-24-81-4-30-2-3-2-2-1-1-13-1-1+HLA-Aw1-8-15-59-22-72-18-23-7-9-17-2-10-2-4-1-1";
$h_expected_gfe{"222222222"}{"HLA-B"} = "HLA-Bw1-1-2-66-24-81-15-6-1-5-5-1-4-2+HLA-Bw10-6-5-49-19-54-9-3-6-3-13-1-6-1";
$h_expected_gfe{"222222222"}{"HLA-C"} = "HLA-Cw1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1+HLA-Cw22-1-3-79-2-118-2-2-2-3-2-1-1-1-2-1-1";
$h_expected_gfe{"333333333"}{"HLA-A"} = "HLA-Aw1-1-7-20-10-32-7-1-1-1-5-1-4-3-5-1-1+HLA-Aw1-6-5-30-15-48-9-16-1-7-9-2-6-1-9-1-1";
$h_expected_gfe{"333333333"}{"HLA-B"} = "HLA-Bw10-8-11-53-21-63-14-13-5-6-15-1-1-2+HLA-Bw13-1-4-24-7-24-5-6-1-5-5-1-4-2";
$h_expected_gfe{"333333333"}{"HLA-C"} = "HLA-Cw1-5-5-22-8-50-8-9-1-6-7-1-1-1-1-1-1+HLA-Cw22-1-8-12-2-64-17-2-2-4-2-1-1-1-1-1-1";
$h_expected_gfe{"444444444"}{"HLA-A"} = "HLA-Aw1-5-4-5-4-9-2-4-2-3-2-2-1-1-2-1-1+HLA-Aw1-8-12-45-19-65-15-10-7-9-13-2-3-2-4-1-1";
$h_expected_gfe{"444444444"}{"HLA-B"} = "HLA-Bw10-10-15-78-32-115-21-7-3-6-20-1-10-2+HLA-Bw10-8-11-115-35-128-14-13-5-6-15-1-1-2";
$h_expected_gfe{"444444444"}{"HLA-C"} = "HLA-Cw22-1-3-78-16-139-20-24-2-10-14-1-13-1-1-1-1+HLA-Cw22-1-9-40-2-72-12-2-2-3-2-1-1-1-2-1-1";

my $r_hml_file2 = dancer_response POST => '/api/v1/flowhml?type=xml', {files => [{name => 'file', filename => $t_file}]};
my $parser = new XML::DOM::Parser;
my $doc    = $parser->parse($r_hml_file2->{content});
my $root   = $doc->getDocumentElement();

ok(defined $r_hml_file2->{content},"API successfully accepted a HML file");
ok(defined $doc,"API XML successfully accepted a HML file");

foreach my $ra_sample (sort @{$root->getElementsByTagName('sample')}){
    my $s_id = $ra_sample->getAttributes->{id}->getValue;
    foreach my $ra_typing (sort @{$ra_sample->getElementsByTagName('typing')}){
        my $s_locus = ${${$ra_typing->getElementsByTagName('typing-method')}[0]->getElementsByTagName('sbt-ngs')}[0]->[1]->{locus}->getValue;
        foreach my $ra_glstring (sort @{${$ra_typing->getElementsByTagName('allele-assignment')}[0]->getElementsByTagName('glstring')}){
            my $s_gfe = ${${$ra_typing->getElementsByTagName('allele-assignment')}[0]->getElementsByTagName('glstring')}[1]->[0]->[0]->toString;
            ok($s_gfe eq $h_expected_gfe{$s_id}{$s_locus},"GFE in HML is correct");
        }
    }
}

my $r_hml_file = dancer_response POST => '/api/v1/flowhml', {files => [{name => 'file', filename => $t_file}]};
ok(defined $r_hml_file->{content},"API successfully accepted a HML file");
ok(defined $r_hml_file->{content}->{subjects},"API successfully subject GFE results from HML");
ok(defined $r_hml_file->{content}->{subjects}[1],"size subjects > 0");
ok(defined $r_hml_file->{content}->{subjects}[0]->{typingData}[0],"Subject typing data returned from HML input");
ok(defined $r_hml_file->{content}->{subjects}[0]->{typingData}[0]->{typing}[0],"Typing data returned from HML input");
ok(defined $r_hml_file->{content}->{subjects}[0]->{typingData}[0]->{typing}[0]->{gfe},"API successfully subject GFE results from HML");






