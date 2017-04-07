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
use XML::DOM;

Dancer::Plugin::Swagger->instance->{doc}->{info}{title}             = "Gene Feature Enumeration Service";
Dancer::Plugin::Swagger->instance->{doc}->{info}{description}       = 
    join("<br>",
    "The Gene Feature Enumeration (GFE) Submission service provides an API for converting raw sequence data to GFE. It provides both a RESTful API and a simple user interface for converting raw sequence data to GFE results. Sequences can be submitted one at a time or as a fasta file. This service uses <a href=\"https://github.com/nmdp-bioinformatics/service-feature\">nmdp-bioinformatics/service-feature</a> for encoding the raw sequence data and <a href=\"https://github.com/nmdp-bioinformatics/HSA\">nmdp-bioinformatics/HSA</a> for aligning the raw sequence data. The code is open source, and available on <a href=\"https://github.com/nmdp-bioinformatics/service-gfe-submission\">GitHub</a>.<br>",
    "Go to <a href=\"http://service-gfe-submission.readthedocs.io\">service-gfe-submission.readthedocs.io</a> for more information"
    );
Dancer::Plugin::Swagger->instance->{doc}->{info}{version}           = "1.0.7";
Dancer::Plugin::Swagger->instance->{doc}->{info}{contact}{email}    = "mhalagan\@nmdp.org";
Dancer::Plugin::Swagger->instance->{doc}->{info}{license}{name}     = "GNU GENERAL PUBLIC LICENSE";
Dancer::Plugin::Swagger->instance->{doc}->{info}{license}{url}      = "https://www.gnu.org/licenses/lgpl.html";


=head2 getGfe API Call


=cut
swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from sequence and locus',
    parameters => [
        {  
            in => 'query',
            name => 'locus',
            type => 'string',
            description => 'Valid HLA, KIR or ABO locus'
        },
        {   name => 'sequence',
            type => 'string',
            description => 'Sequence data',
            in => 'query',
        },
        {   name => 'retry',
            type => 'integer',
            description => 'Number of retry requests to feature-service',
            in => 'query',
        },
        {   name => 'feature_url',
            type => 'string',
            description => 'URL for the feature-service',
            in => 'query',
        },
        {   name => 'structures',
            type => 'boolean',
            description => 'Flag for returning the sequence and accession number of each feature',
            in => 'query',
        },
        {   name => 'verbose',
            type => 'boolean',
            description => 'Flag for running service in verbose',
            in => 'query',
        },
    ],
    responses => {
        404 => {
            description => 'Failed to generate GFE',
            schema => { '$ref' => "#/definitions/Error" },
        },

        200 => {
            description => 'Gene Feature Enumeration (GFE)',
            schema  => { '$ref' => "#/definitions/Typing" },
        },
    },
},
post '/gfe' => sub {

    my $s_url        = params->{'feature_url'};
    my $s_locus      = params->{'locus'};
    my $n_retry      = params->{'retry'};
    my $b_verbose    = params->{'verbose'};
    my $s_sequence   = params->{'sequence'};
    my $b_structures = params->{'structures'};

    my $o_gfe = GFE->new();
    $o_gfe->return_structure($b_structures eq "true" || $b_structures eq "1" ? 1 : 0) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose eq "true" || $b_verbose eq "1" ? 1 : 0) 
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

    content_type 'application/json';
    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe;

};


=head2 getGfe API Call


=cut
swagger_path {
    description => 'Get sequence data from gene feature enumeration (GFE) annotation',
    parameters => [
        {  
            in => 'query',
            name => 'locus',
            type => 'string',
            description => 'Valid HLA, KIR or ABO locus',
        },
        {   name => 'gfe',
            type => 'string',
            description => 'GFE annotation',
            in => 'query',
        },
        {   name => 'retry',
            type => 'integer',
            description => 'Number of retry requests to feature-service',
            in => 'query',
        },
        {   name => 'feature_url',
            type => 'string',
            description => 'URL for the feature-service',
            in => 'query',
        },
        {   name => 'structures',
            type => 'boolean',
            description => 'Flag for returning the sequence and accession number of each feature',
            in => 'query',
        },
        {   name => 'verbose',
            type => 'boolean',
            description => 'Flag for running service in verbose',
            in => 'query',
        },
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

    my $s_url        = params->{'feature_url'};
    my $s_gfe        = params->{'gfe'};
    my $n_retry      = params->{'retry'};
    my $s_locus      = params->{'locus'};
    my $b_verbose    = params->{'verbose'};
    my $b_structures = params->{'structures'};

    my $o_gfe = GFE->new();
    
    $o_gfe->return_structure($b_structures eq "true" || $b_structures eq "1" ? 1 : 0) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose eq "true" || $b_verbose eq "1" ? 1 : 0) 
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

    content_type 'application/json';
    return defined $$rh_seq{Error} ? swagger_template 404, $$rh_seq{Error}
        : swagger_template 200, $rh_seq;

};


=head2 getGfeFasta API Call


=cut
swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from HML file',
    parameters => [
        {
            name => 'file',
            type => 'file',
            description => 'HML file',
            in => 'formData',
        },
        {   name => 'type',
            type => 'string',
            description => 'Option for returning HML or JSON',
            in => 'query',
        },
        {   name => 'feature_url',
            type => 'string',
            description => 'URL for the feature-service',
            in => 'query',
        },
        {   name => 'retry',
            type => 'integer',
            description => 'Number of retry requests to feature-service',
            in => 'query',
        },        
        {   name => 'structures',
            type => 'boolean',
            description => 'Flag for returning the sequence and accession number of each feature',
            in => 'query',
        },
        {   name => 'verbose',
            type => 'boolean',
            description => 'Flag for running service in verbose',
            in => 'query',
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

    my $s_url          = params->{'feature_url'};
    my $n_retry        = params->{'retry'};
    my $b_verbose      = params->{'verbose'};
    my $b_structures   = params->{'structures'};
    my $s_input_file   = defined params->{'file'} ? request->upload('file') : undef;
    my $s_content_type = defined params->{'type'} ? params->{'type'} : undef;

    if(defined $s_input_file && $s_input_file =~ /\S/){
        if(-e $s_input_file->filename){       
           $s_input_file = $s_input_file->filename;
        }else{
            $s_input_file->copy_to("public/downloads/".$s_input_file->basename);
            $s_input_file = "public/downloads/".$s_input_file->basename;
        }
    }

    my $o_gfe = GFE->new();
    $o_gfe->return_structure($b_structures eq "true" || $b_structures eq "1" ? 1 : 0) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose eq "true" || $b_verbose eq "1" ? 1 : 0) 
        if(defined $b_verbose && $b_verbose =~ /\S/);

    if(defined $s_url || defined $n_retry){
        my $o_client = GFE::Client->new();
        $o_client->feature_url($s_url) 
            if(defined $s_url && $s_url =~ /\S/);
        $o_client->retry($n_retry) 
            if(defined $n_retry && $n_retry =~ /\S/);
        $o_gfe->client($o_client);
    }

    my $rh_gfe       = $o_gfe->getGfeHml($s_input_file);

    content_type 'application/json';
    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe if((defined $s_content_type && $s_content_type =~ /json/i) || !defined $s_content_type);

    my %h_subjects;
    my $s_version = $$rh_gfe{version};
    foreach my $rh_subject (@{$$rh_gfe{subjects}}){
        my $s_id = $$rh_subject{id};
        $s_id =~ s/-0$//;
        foreach my $rh_typing_data (@{$$rh_subject{typingData}}){
            my $s_locus = $$rh_typing_data{locus};
            my $gfe_gl = join("+",map{ my $tmp = $_;$tmp->{gfe} } @{$$rh_typing_data{typing}});
            $h_subjects{$s_id}{$s_locus} = $gfe_gl;
        }
    }

    my $parser = new XML::DOM::Parser;
    my $doc    = $parser->parsefile ($s_input_file);
    my $root   = $doc->getDocumentElement();

    foreach my $ra_sample (@{$root->getElementsByTagName('sample')}){

        my $s_id = $ra_sample->getAttributes->{id}->getValue;
        next if !defined $h_subjects{$s_id};
        foreach my $ra_typing (@{$ra_sample->getElementsByTagName('typing')}){

            my $s_locus = ${${$ra_typing->getElementsByTagName('typing-method')}[0]->getElementsByTagName('sbt-ngs')}[0]->[1]->{locus}->getValue;

            if(defined $h_subjects{$s_id}{$s_locus}){
                my $newGfeElement = $doc->createElement('allele-assignment');
                my $date          = strftime "%Y-%m-%d", localtime;
                $newGfeElement->setAttribute("date",$date);
                my $s_feature_url = $o_gfe->client->feature_url;
                $newGfeElement->setAttribute("allele-db",$s_feature_url);
                $newGfeElement->setAttribute("allele-version",$$rh_gfe{version});
                my $newglElement = $doc->createElement('glstring');
                my $gfe_glstring = $doc->createTextNode($h_subjects{$s_id}{$s_locus});
                $newglElement->appendChild($gfe_glstring);
                $newGfeElement->appendChild($newglElement);
                $ra_typing->appendChild($newGfeElement);
            }
        }
    }

    content_type 'text/xml';
    return $doc->toString;

};


=head2 getGfeHmlNextflow API Call


=cut
swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from HML file using nextflow',
    parameters => [
        {
            name => 'file',
            type => 'file',
            description => 'HML file',
            in => 'formData',
        },
        {   name => 'type',
            type => 'string',
            description => 'Option for returning HML or JSON',
            in => 'query',
        },
        {   name => 'feature_url',
            type => 'string',
            description => 'URL for the feature-service',
            in => 'query',
        },
        {   name => 'retry',
            type => 'integer',
            description => 'Number of retry requests to feature-service',
            in => 'query',
        },        
        {   name => 'structures',
            type => 'boolean',
            description => 'Flag for returning the sequence and accession number of each feature',
            in => 'query',
        },
        {   name => 'verbose',
            type => 'boolean',
            description => 'Flag for running service in verbose',
            in => 'query',
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
post '/flowhml' => sub {

    my $s_url          = params->{'feature_url'};
    my $n_retry        = params->{'retry'};
    my $b_verbose      = params->{'verbose'};
    my $b_structures   = params->{'structures'};
    my $s_input_file   = defined params->{'file'} ? request->upload('file') : undef;
    my $s_content_type = defined params->{'type'} ? params->{'type'}        : undef;

    if(defined $s_input_file && $s_input_file =~ /\S/){
        if(-e $s_input_file->filename){       
           $s_input_file = $s_input_file->filename;
        }else{
            $s_input_file->copy_to("public/downloads/".$s_input_file->basename);
            $s_input_file = "public/downloads/".$s_input_file->basename;
        }
    }

    my $o_gfe = GFE->new();
    $o_gfe->return_structure($b_structures eq "true" || $b_structures eq "1" ? 1 : 0) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose eq "true" || $b_verbose eq "1" ? 1 : 0) 
        if(defined $b_verbose && $b_verbose =~ /\S/);

    if(defined $s_url || defined $n_retry){
        my $o_client = GFE::Client->new();
        $o_client->feature_url($s_url) 
            if(defined $s_url && $s_url =~ /\S/);
        $o_client->retry($n_retry) 
            if(defined $n_retry && $n_retry =~ /\S/);
        $o_gfe->client($o_client);
    }

    my $rh_gfe       = $o_gfe->getGfeHmlNextflow($s_input_file);

    content_type 'application/json';
    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe if((defined $s_content_type && $s_content_type =~ /json/i) || !defined $s_content_type);

    my %h_subjects;
    my $s_version = $$rh_gfe{version};
    foreach my $rh_subject (@{$$rh_gfe{subjects}}){
        my $s_id = $$rh_subject{id};
        $s_id =~ s/-0$//;
        foreach my $rh_typing_data (sort @{$$rh_subject{typingData}}){
            my $s_locus = $$rh_typing_data{locus};
            my $gfe_gl  = join("+",sort map{ my $tmp = $_;$tmp->{gfe} } @{$$rh_typing_data{typing}});
            $h_subjects{$s_id}{$s_locus} = $gfe_gl;
        }
    }

    my $parser = new XML::DOM::Parser;
    my $doc    = $parser->parsefile($s_input_file);
    my $root   = $doc->getDocumentElement();

    foreach my $ra_sample (sort @{$root->getElementsByTagName('sample')}){

        my $s_id = $ra_sample->getAttributes->{id}->getValue;
        next if !defined $h_subjects{$s_id};

        foreach my $ra_typing (sort @{$ra_sample->getElementsByTagName('typing')}){
            my $s_locus = ${${$ra_typing->getElementsByTagName('typing-method')}[0]->getElementsByTagName('sbt-ngs')}[0]->[1]->{locus}->getValue;
            if(defined $h_subjects{$s_id}{$s_locus}){
                my $newGfeElement = $doc->createElement('allele-assignment');
                my $date          = strftime "%Y-%m-%d", localtime;
                $newGfeElement->setAttribute("date",$date);
                my $s_feature_url = $o_gfe->client->feature_url;
                $newGfeElement->setAttribute("allele-db",$s_feature_url);
                $newGfeElement->setAttribute("allele-version",$$rh_gfe{version});
                my $newglElement = $doc->createElement('glstring');
                my $gfe_glstring = $doc->createTextNode($h_subjects{$s_id}{$s_locus});
                $newglElement->appendChild($gfe_glstring);
                $newGfeElement->appendChild($newglElement);
                $ra_typing->appendChild($newGfeElement);
            }
        }
    }

    content_type 'text/xml';
    return $doc->toString;

};



=head2 getGfeFasta API Call


=cut
swagger_path {
    description => 'Get Gene Feature Enumeration (GFE) from fasta file',
    parameters => [
        {
            name => 'locus',
            type => 'string',
            description => 'Valid HLA, KIR or ABO locus',
            in => 'formData',
         },
         {
            name => 'file',
            type => 'file',
            description => 'HML file',
            in => 'formData',
         },
        {   name => 'retry',
            type => 'integer',
            description => 'Number of retry requests to feature-service',
            in => 'query',
        },
        {   name => 'feature_url',
            type => 'string',
            description => 'URL for the feature-service',
            in => 'query',
        },
        {   name => 'structures',
            type => 'boolean',
            description => 'Flag for returning the sequence and accession number of each feature',
            in => 'query',
        },
        {   name => 'verbose',
            type => 'boolean',
            description => 'Flag for running service in verbose',
            in => 'query',
        }
    ],
    responses => {
        404 => {
            description => 'Failed to generate GFE from fasta',
            schema => { '$ref' => "#/definitions/Error" },
        },
        200 => {
            description => 'Gene Feature Enumeration (GFE) from fasta file',
            schema  => { '$ref' => "#/definitions/SubjectData" },
        },
    },
},
post '/fasta' => sub {

    my $s_url        = params->{'feature_url'};
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
    $o_gfe->return_structure($b_structures eq "true" || $b_structures eq "1" ? 1 : 0) 
        if(defined $b_structures && $b_structures =~ /\S/);

    $o_gfe->verbose($b_verbose eq "true" || $b_verbose eq "1" ? 1 : 0) 
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

    content_type 'application/json';
    return defined $$rh_gfe{Error} ? swagger_template 404, $$rh_gfe{Error}
        : swagger_template 200, $rh_gfe;

};



1;