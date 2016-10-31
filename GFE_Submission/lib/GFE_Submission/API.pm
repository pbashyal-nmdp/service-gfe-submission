#!/usr/bin/env perl
package GFE_Submission::API;
use strict;
use warnings;

use GFE::Client;
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
            schema => { '$ref' => "#/definitions/Error" },
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
    my $b_verbose    = params->{'verbose'};

    $o_gfe->verbose($b_verbose) 
        if(defined $b_verbose && $b_verbose =~ /\S/);

    $o_gfe->client(GFE::Client->new(url => $url)) 
        if(defined $url && $url =~ /\S/);

	my $rh_gfe       = $o_gfe->getGfe($s_locus,$s_sequence);

    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe;

};


1;