#!/usr/bin/env perl
=head1 NAME

    gfe-submission

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
    
    Version    Description              Date


=head1 TODO
    

=head1 SUBROUTINES

=cut
use strict;    # always
use warnings;  # or else
use FindBin;
use Data::Dumper;
use FindBin;
use lib "$FindBin::Bin/../lib";
use GFE;
use GFE::Client;
use GFE::Annotate;


my $o_gfe  = GFE->new();
$o_gfe->verbose(1);
$o_gfe->return_structure(0);

# my $s_path = `echo \$PATH`;chomp($s_path);
# foreach my $s_p (split(/:/,$s_path)){
#     print STDERR "PATH: ".$s_p,"\n";
# }

my $s_hml   = "$FindBin::Bin/../t/resources/hmltest1.HML";
my $rh_gfe  = $o_gfe->getGfeHmlNextflow($s_hml);
print STDERR "gfe_test.pl output:",Dumper($rh_gfe),"\n";
# my %h_seqs;
# my $s_header;
# my $s_seq;
# while (<>) {
#     chomp;
#     if ($_ =~ />/) {
#         if ($s_seq) {    
#             $h_seqs{$s_header} = $s_seq;
#         }              
#         $s_header = $_;
#         $s_header =~ s/^>//; # remove ">"
#         $s_header =~ s/\s+$//; # remove trailing whitespace
#         $s_seq = ""; # clear out old sequence
#     }else {    
#         s/\s+//g; # remove whitespace
#         $s_seq .= $_; # add sequence
#     }
# }

# if ($s_seq) { # handle last sequence
#     $h_seqs{$s_header} = $s_seq;
# }

# foreach my $s_typing (keys %h_seqs){
#   $s_typing =~ /(HLA-\D+\d{0,1})\*/;
#   my $s_locus = $1;
#   next if(!defined $s_locus || $s_locus !~ /\S/);
#   my $rh_gfe = $o_gfe->getGfe($s_locus,$h_seqs{$s_typing});
#   my $s_gfe  = defined $$rh_gfe{gfe} ? $$rh_gfe{gfe} : '';
#   my $n_seq  = length($h_seqs{$s_typing});
#   print join(",",$s_locus,$s_typing,$n_seq,$s_gfe),"\n";
# }






























 


