#!/usr/bin/env perl
=head1 NAME

    GFE_Client

=head1 SYNOPSIS


=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

=head1 DESCRIPTION

    This script takes in the output of ngs-validate-interp and the observed file and generates
    a static HTML website report.


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

=head1 SUBROUTINES

=cut
package GFE_Client;
use strict;
use warnings;

use JSON;
use Moose;
use Data::Dumper;
use REST::Client;
use LWP::UserAgent;
use HTTP::Request::Common;



our $VERSION = '1.0.2';

has 'gfe_url' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'verbose' => (
    is => 'rw',
    isa => 'Bool',
    required => 1
);

has 'structures' => (
    is => 'rw',
    isa => 'Bool',
    required => 1
);

=head2 redux

    
=cut
sub getGfe{

    my($self,$s_loc,$s_seq) = @_;

    my $request = {
        locus    => $s_loc,
        sequence => $s_seq
    };
    my $json_request = JSON::to_json($request);
    my $client = REST::Client->new({
            host    => $self->gfe_url,
        });
    $client->addHeader('Content-Type', 'application/json;charset=UTF-8');
    $client->addHeader('Accept', 'application/json');

    # List of haplotypes based on the first population
    $client->POST('/gfe', $json_request, {});

    my $json_response = $client->responseContent;
    my $response = JSON::from_json($json_response);

    return $response;

}

=head2 getGfeFasta

    
=cut
sub getGfeFasta{

    my($self,$s_loc,$s_fasta) = @_;

    my $ua = LWP::UserAgent->new;
    my $json_response = $ua->request(
        POST $self->{gfe_url}."/fasta",
            Content_Type => 'form-data',
            Content => [
                file => [ $s_fasta ],
                locus      => $s_loc,
                structures => $self->{structures},
                verbose    => $self->{verbose},
            ]
    );
    my $response = JSON::from_json($json_response->content);
    return $response;

}


=head2 getGfeHml

    
=cut
sub getGfeHml{

    my($self,$s_type,$s_hml) = @_;

    my $ua = LWP::UserAgent->new;
    my $api_response = $ua->request(
        POST $self->{gfe_url}."/hml",
            Content_Type => 'form-data',
            Content => [
                file       => [ $s_hml ],
                type      => $s_type,
                structures => $self->{structures},
                verbose    => $self->{verbose},
            ]
    );

    if($s_type ne "JSON"){
        return $api_response->content;
    }else{
        my $response = JSON::from_json($api_response->content);
        return $response;
    }

}

=head2 getGfeHml

    
=cut
sub getGfeHmlFlow{

    my($self,$s_type,$s_hml) = @_;

    my $ua = LWP::UserAgent->new;
    my $api_response = $ua->request(
        POST $self->{gfe_url}."/api/v1/flowhml",
            Content_Type => 'form-data',
            Content => [
                file       => [ $s_hml ],
                type       => $s_type,
                structures => $self->{structures},
                verbose    => $self->{verbose},
            ]
    );

    if($s_type ne "JSON"){
        return $api_response->content;
    }else{
        my $response = JSON::from_json($api_response->content);
        return $response;
    }

}

=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
  my $orig=shift;
  my $class=shift;
  my $args=shift; 

  $args->{gfe_url}    = "http://localhost:5000";
  $args->{verbose}    = 1;
  $args->{structures} = 1;
  return $class->$orig($args);
};

__PACKAGE__->meta->make_immutable;


1;