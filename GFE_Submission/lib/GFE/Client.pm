#!/usr/bin/env perl
=head1 NAME
 
Client

=head1 SYNOPSIS


=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

=head1 DESCRIPTION



=head1 CAVEATS
	

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

=head1 VERSIONS
	
    Version    		Description             	Date


=head1 TODO
	

=head1 SUBROUTINES

=cut
package GFE::Client;
use strict;
use warnings;
use REST::Client;
use JSON;

use Log::Log4perl;
use Data::Dumper;
use Try::Tiny;
use Moose;


has 'feature_url' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'retry' => (
    is => 'rw',
    isa => 'Int',
    required => 1
);

=head2 gfe_post

    Title:     gfe_post
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub getAccesion{
    
    my($self,$s_locus,$s_term,$n_rank,$s_seq) = @_;

    my $n_retry = 0;
    my $logger  = Log::Log4perl->get_logger();

    RETRY:

    my $request = {
        "locus"    => $s_locus,
        "term"     => $s_term,
        "rank"     => $n_rank,
        "sequence" => $s_seq
    };
    my $json_request = JSON::to_json($request);

    my $client = REST::Client->new({
            host    => $self->feature_url,
        });
    $client->addHeader('Content-Type', 'application/json;charset=UTF-8');
    $client->addHeader('Accept', 'application/json');

    # List of haplotypes based on the first population
    $client->POST('/features', $json_request, {});

    my $response;
    my $json_response = $client->responseContent;
    try {
      $response      = JSON::from_json($json_response);
    } catch {
      $logger->error("Failed to decode json!");
    };

    return $$response{accession} if defined $$response{accession};
    
    if($n_retry < $self->retry){ 
        $n_retry++;
        $logger->info("Retrying submission to GFE service.. retry #".$n_retry." | ".join(" ",$s_locus,$s_term,$n_rank));
        goto RETRY;
    }else{
        $logger->error("No accession number could be assigned!");
        $logger->error(join("|","LOCUS      $s_locus","TERM       $s_term","RANK       $n_rank","SEQUENCE  $s_seq"));
    }
    
    return 0;

}

=head2 gfe_post

    Title:     gfe_post
    Usage:     
    Function:  
    Returns:  
    Args:      

=cut
sub getSequence{
    
    my($self,$s_locus,$s_term,$n_rank,$s_accesion) = @_;

    my $n_retry = 0;
    my $logger  = Log::Log4perl->get_logger();

    RETRY:

    my $request = {
        "locus"     => $s_locus,
        "term"      => $s_term,
        "rank"      => $n_rank,
        "accession" => $s_accesion
    };
    my $json_request = JSON::to_json($request);

    my $client = REST::Client->new({
            host    => $self->feature_url,
        });
    $client->addHeader('Content-Type', 'application/json;charset=UTF-8');
    $client->addHeader('Accept', 'application/json');

    my $s_get_request = "/$s_locus/$s_term/$n_rank/$s_accesion";
    # List of haplotypes based on the first population
    $client->GET('/features'.$s_get_request);

    my $response;
    my $json_response = $client->responseContent;
    try {
      $response      = JSON::from_json($json_response);
    } catch {
      $logger->error("Failed to decode json!");
    };

    return $$response{sequence} if defined $$response{sequence};

    if($n_retry < $self->retry){ 
        $n_retry++;
        $logger->info("Retrying accession submission to feature service.. retry #".$n_retry." | ".join(" ",$s_locus,$s_term,$n_rank,$s_accesion));
        goto RETRY;
    }else{
        $logger->error("No sequence could be found!");
        $logger->error(join("|","LOCUS      $s_locus","TERM       $s_term","RANK       $n_rank","ACCESSION  $s_accesion"));
    }
    
    return '';

}


=head2 BUILDARGS


=cut
around BUILDARGS=>sub
{
  my $orig=shift;
  my $class=shift;
  my $args=shift; 

  $args->{feature_url}    = "http://feature.nmdp-bioinformatics.org";
  $args->{retry}          = 6;
  return $class->$orig($args);
};

__PACKAGE__->meta->make_immutable;
1;