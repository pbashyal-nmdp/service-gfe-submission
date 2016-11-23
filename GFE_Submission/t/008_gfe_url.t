=head1 NAME
 
   008_gfe_url.t

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
use Test::More tests => 5;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use GFE;

# Create client object
my $o_client       = GFE::Client->new();
ok(defined $o_client,"GFE Client Object created");

$o_client->feature_url("http://localhost:3000");
ok($o_client->feature_url eq "http://localhost:3000","GFE Client feature url works");

ok($o_client->retry == 6,"GFE Client retry number correctly set to default");
$o_client->retry(2);
ok($o_client->retry == 2,"GFE Client retry number correctly changed");

my $o_gfe          = GFE->new();
$o_gfe->client($o_client);
ok(defined $o_gfe,"GFE Object created with new client url");





