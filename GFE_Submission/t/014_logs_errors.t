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

my @a_align_undef   = grep{ $_ =~ /Alignment ran but files are empty/ } @{$ra_logs_align};
ok(defined $a_align_undef[0],"Alignment ran but files are empty");

