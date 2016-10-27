#!/usr/bin/env perl
package GFE_Submission::API;
use strict;
use warnings;

use Dancer ':syntax';
use POSIX qw(strftime);
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;

prefix '/api/v1';

my $o_gfe;
sub setGfe{ $o_gfe = shift; } 


=head2 getGfe API Call


=cut

swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from sequence and locus',
    parameters => [
     	{
    	    name => 'GfeSubmission',
    		type => 'object',
    		schema => { '$ref' => "#/definitions/GfeSubmission" },
            description => 'GFE Submission',
            in => 'body',
         }
    ],
    responses => {
        404 => {
            template => sub { +{ error => "'@{[ shift ]}' failed to get accesion number" } },
            schema   => {
                type => 'object',
                required => [ 'error' ],
                properties => {
                    error => { type => 'string' },
                }
            },
        },

        200 => {
            description => 'Gene Feature Enumeration (GFE)',
            schema  => { '$ref' => "#/definitions/Gfe" },
        },

    },
},
post '/gfe' => sub {

	my $url          = params->{'url'};
	my $s_locus      = params->{'locus'};
	my $s_sequence   = params->{'sequence'};

	my $s_gfe        = $o_gfe->getGfe($s_locus,$s_sequence);

	return $s_gfe;

};


1;