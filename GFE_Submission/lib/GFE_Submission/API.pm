#!/usr/bin/env perl
=head1 NAME
 
GFE_Submission::API
 
=cut
package GFE_Submission::API;
use strict;
use warnings;

use GFE;
use GFE::Client;
use Dancer ':syntax';
use POSIX qw(strftime);
use Dancer::Request::Upload;
use Dancer::Plugin::Swagger;
use GFE_Submission::Definitions;
use Data::Dumper;

prefix '/api/v1';


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
            description => 'Failed to generate GFE',
            schema => { '$ref' => "#/definitions/Error" },
        },

        200 => {
            description => 'Gene Feature Enumeration (GFE)',
            schema  => { '$ref' => "#/definitions/Gfe" },
        },
    },
},
post '/gfe' => sub {

	my $s_url        = params->{'url'};
	my $s_locus      = params->{'locus'};
    my $n_retry      = params->{'retry'};
    my $b_verbose    = params->{'verbose'};
	my $s_sequence   = params->{'sequence'};
    my $b_structures = params->{'structures'};

    my $o_gfe = GFE->new();

    $o_gfe->return_structure($b_structures) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose) 
        if(defined $b_verbose && $b_verbose =~ /\S/);

    if(defined $s_url || defined $n_retry){
        my $o_client = GFE::Client->new();
        $o_client->feature_url($s_url) 
            if(defined $s_url && $s_url =~ /\S/);
        $o_client->retry($n_retry) 
            if(defined $n_retry && $n_retry =~ /\S/);
        $o_gfe->client($o_client);
    }

	my $rh_gfe       = $o_gfe->getGfe($s_locus,$s_sequence);

    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe;

};


=head2 getGfe API Call


=cut
swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from sequence and locus',
    parameters => [
        {
            name   => 'SequenceSubmission',
            type   => 'object',
            schema => { '$ref' => "#/definitions/SequenceSubmission" },
            description => 'Sequence submission',
            in => 'body',
         }
    ],
    responses => {
        404 => {
            description => 'Failed to get sequence from GFE',
            schema => { '$ref' => "#/definitions/Error" },
        },
        200 => {
            description => 'Sequence',
            schema  => { '$ref' => "#/definitions/Sequence" },
        },
    },
},
post '/sequence' => sub {

    my $s_url        = params->{'url'};
    my $s_gfe        = params->{'gfe'};
    my $n_retry      = params->{'retry'};
    my $s_locus      = params->{'locus'};
    my $b_verbose    = params->{'verbose'};
    my $b_structures = params->{'structures'};

    my $o_gfe = GFE->new();

    $o_gfe->return_structure($b_structures) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose) 
        if(defined $b_verbose && $b_verbose =~ /\S/);

    if(defined $s_url || defined $n_retry){
        my $o_client = GFE::Client->new();
        $o_client->feature_url($s_url) 
            if(defined $s_url && $s_url =~ /\S/);
        $o_client->retry($n_retry) 
            if(defined $n_retry && $n_retry =~ /\S/);
        $o_gfe->client($o_client);
    }

    my $rh_seq       = $o_gfe->getSequence($s_locus,$s_gfe);

    return defined $$rh_seq{Error} ? swagger_template 404, $$rh_seq{Error}
        : swagger_template 200, $rh_seq;

};


=head2 getGfeFasta API Call


=cut
swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from HML file',
    parameters => [
        {
            name => 'HmlSubmission',
            type => 'object',
            schema => { '$ref' => "#/definitions/HmlSubmission" },
            description => 'HML GFE Submission',
            in => 'body',
         }
    ],
    responses => {
        404 => {
            description => 'Failed to generate GFE',
            schema => { '$ref' => "#/definitions/Error" },
        },

        200 => {
            description => 'Gene Feature Enumeration (GFE) from HML file',
            schema  => { '$ref' => "#/definitions/SubjectData" },
        },
    },
},
post '/hml' => sub {

    my $s_url        = params->{'url'};
    my $n_retry      = params->{'retry'};
    my $b_verbose    = params->{'verbose'};
    my $b_structures = params->{'structures'};
    my $s_input_file = defined params->{'file'} ? request->upload('file') : undef;

    if(defined $s_input_file && $s_input_file =~ /\S/){
        if(-e $s_input_file->filename){       
           $s_input_file = $s_input_file->filename;
        }else{
            $s_input_file->copy_to("public/downloads/".$s_input_file->basename);
            $s_input_file = "public/downloads/".$s_input_file->basename;
        }
    }

    my $o_gfe = GFE->new();

    $o_gfe->return_structure($b_structures) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose) 
        if(defined $b_verbose && $b_verbose =~ /\S/);

    if(defined $s_url || defined $n_retry){
        my $o_client = GFE::Client->new();
        $o_client->feature_url($s_url) 
            if(defined $s_url && $s_url =~ /\S/);
        $o_client->retry($n_retry) 
            if(defined $n_retry && $n_retry =~ /\S/);
        $o_gfe->client($o_client);
    }

    $o_gfe->return_structure(0);
    my $rh_gfe       = $o_gfe->getGfeHml($s_input_file);

    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe;

};


=head2 getGfeFasta API Call


=cut
swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from fasta file',
    parameters => [
        {
            name => 'FastaSubmission',
            type => 'object',
            schema => { '$ref' => "#/definitions/FastaSubmission" },
            description => 'GFE Submission',
            in => 'body',
         }
    ],
    responses => {
        404 => {
            description => 'Failed to generate GFE',
            schema => { '$ref' => "#/definitions/Error" },
        },

        200 => {
            description => 'Gene Feature Enumeration (GFE) from fasta file',
            schema  => { '$ref' => "#/definitions/SubjectData" },
        },
    },
},
post '/fasta' => sub {

    my $s_url        = params->{'url'};
    my $s_locus      = params->{'locus'};
    my $n_retry      = params->{'retry'};
    my $b_verbose    = params->{'verbose'};
    my $b_structures = params->{'structures'};
    my $s_input_file = request->upload('file');

    
    if(defined $s_input_file && $s_input_file =~ /\S/){
        if(-e $s_input_file->filename){       
           $s_input_file = $s_input_file->filename;
        }else{
            $s_input_file->copy_to("public/downloads/".$s_input_file->basename);
            $s_input_file = "public/downloads/".$s_input_file->basename;
        }
    }

    my $o_gfe = GFE->new();
    $o_gfe->return_structure($b_structures) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose) 
        if(defined $b_verbose && $b_verbose =~ /\S/);

    if(defined $s_url || defined $n_retry){
        my $o_client = GFE::Client->new();
        $o_client->feature_url($s_url) 
            if(defined $s_url && $s_url =~ /\S/);
        $o_client->retry($n_retry) 
            if(defined $n_retry && $n_retry =~ /\S/);
        $o_gfe->client($o_client);
    }

    my $rh_gfe      = $o_gfe->getGfeFasta($s_locus,$s_input_file);

    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe;

};



1;