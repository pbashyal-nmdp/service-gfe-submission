#!/usr/bin/env perl
=head1 NAME
 
GFE_Submission - Service for getting a GFE from raw sequence data. 

=head1 SYNOPSIS


=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

=head1 DESCRIPTION



=head1 CAVEATS
	

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

=head1 VERSIONS
	
    Version    		Description             	Date


=head1 TODO
	

=head1 SUBROUTINES

=cut
package GFE_Submission;
use Dancer ':syntax';
use strict;
use warnings;

use Dancer::Plugin::Swagger;
use Data::Dumper;
use POSIX qw(strftime);
use GFE_Submission::Definitions;
use GFE_Submission::API;
use GFE;

my $o_gfe = GFE->new();

our $VERSION = '1.1.1';

prefix undef;

=head2 after hook


=cut
hook 'after' => sub {
    $o_gfe = GFE->new();
    $o_gfe->deleteOldFiles();
};

=head2 index


=cut
get '/' => sub {
    template 'index';
};

=head2 about

	
=cut
get '/about' => sub {
    template 'about';
};

=head2 contact

	
=cut
get '/contact' => sub {
    template 'contact';
};


=head2 clients

	
=cut
get '/soon' => sub {
    template 'soon';
};


=head2 clients

	
=cut
get '/clients' => sub {
    template 'clients';
};

=head2 download

	
=cut
get '/download' => sub {

	my $client_type = params->{type};
	$client_type = defined $client_type ? $client_type : "ars_file";

	if($client_type eq "ars_file"){
		redirect '/';
	}else{
		redirect '/clients';
	}

};


=head2 gfe

    Route for displaying the webpage and UI. For the Swagger
    interface refer to the GFE_Submission::API module and click
    API from the main UI to see the Swagger UI.

    ** Not the RESTful API - Refer to GFE_Submission::API **

=cut
get '/gfe_gui' => sub {

	my $url          = params->{'url'};
	my $s_locus      = params->{'locus'};
	my $s_sequence   = params->{'sequence'};

    $o_gfe->verbose(1);
    $o_gfe->client(GFE::Client->new(url => $url)) if(defined $url && $url =~ /\S/);
    my $rh_gfe        = $o_gfe->getGfe($s_locus,$s_sequence);
    if(defined  $$rh_gfe{Error}){
        template 'index', {
            'Error'        => $$rh_gfe{Error}
        };
    }else{
		template 'index', {
		    'gfe'        => $$rh_gfe{gfe},
		    'structures' => $$rh_gfe{structure},
            'log'        => $$rh_gfe{log}
		};
    }
	
	

};



true;