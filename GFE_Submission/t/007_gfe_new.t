use Test::More tests => 1;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use GFE::Client;
use GFE;

my $number_of_tests_run = 0; # Number of tests run
my $o_gfe               = GFE->new();

ok(defined $o_gfe,"GFE Object created");

