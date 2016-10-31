use Test::More tests => 1;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use GFE;

my $o_client       = GFE::Client->new(url => "http://localhost:3000");
my $o_gfe          = GFE->new();
$o_gfe->client($o_client);

ok(defined $o_gfe,"GFE Object created with new client url");