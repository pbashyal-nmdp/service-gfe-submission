use Test::More tests => 2;
use strict;
use warnings;
use Data::Dumper;
# the order is important
use Dancer::Test;
use GFE_Submission;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use GFE_Submission::API;


route_exists [GET => '/about'], 'a route handler is defined for /';
response_status_is [GET => '/about'], 200, 'response status is 200 for /about';
