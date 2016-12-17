=head1 NAME
 
   014_logs_errors.t

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
# the order is important
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;

my $r_verbose_blank = dancer_response POST => '/api/v1/gfe?verbose=1&locus=HLA-A&sequence=';
ok(defined $r_verbose_blank->{content},"r_verbose_blank->{content} defined");
ok(defined $r_verbose_blank->{content}->{type},"r_verbose_blank->{content}->{type} defined");
ok(defined $r_verbose_blank->{content}->{log},"r_verbose_blank->{content}->{log} defined");

my $ra_logs = $r_verbose_blank->{content}->{log};
ok(defined $$ra_logs[0],"size ra_logs > 0");

my @a_error  = grep{ $_ =~ /ERROR/ } @{$ra_logs};
ok(defined $a_error[0],"ERROR size a_error > 0");

my @a_seq_undef   = grep{ $_ =~ /Sequence not defined/ } @{$ra_logs};
ok(defined $a_seq_undef[0],"Sequence not defined found in log");


my $r_verbose_align = dancer_response POST => '/api/v1/gfe?verbose=1&locus=HLA-A&sequence=ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ';
ok(defined $r_verbose_align->{content},"r_verbose_align->{content} defined");
ok(defined $r_verbose_align->{content}->{type},"r_verbose_align->{content}->{type} defined");
ok(defined $r_verbose_align->{content}->{log},"r_verbose_align->{content}->{log} defined");

my $ra_logs_align = $r_verbose_align->{content}->{log};
ok(defined $$ra_logs_align[0],"size ra_logs_align > 0");

my @a_error_align  = grep{ $_ =~ /ERROR/ } @{$ra_logs_align};
ok(defined $a_error_align[0],"ERROR size a_error_align defined");

my @a_align_undef   = grep{ $_ =~ /Failed to create alignment file/ } @{$ra_logs_align};
ok(defined $a_align_undef[0],"Alignment ran but files are empty");

