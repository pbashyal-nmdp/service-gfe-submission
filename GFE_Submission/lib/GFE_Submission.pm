#!/usr/bin/env perl
=head1 NAME
 
GFE_Submission - Service for getting a GFE from raw sequence data. 

=cut

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
package GFE_Submission;
use strict;
use warnings;

use Dancer::Plugin::Swagger;
use Data::Dumper;
use Dancer ':syntax';
use POSIX qw(strftime);
use GFE_Submission::Definitions;
use GFE_Submission::API;
use GFE;

my %h_cache;
my $o_gfe = GFE->new();
GFE_Submission::API::setGfe($o_gfe);

our $VERSION = '0.0.1';

prefix undef;


=head2 index


=cut
get '/' => sub {
	deleteOldFiles();
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


=cut
get '/gfe' => sub {

	my $url          = params->{'url'};
	my $s_locus      = params->{'locus'};
	my $s_sequence   = params->{'sequence'};


	if(defined $h_cache{$s_locus}{$s_sequence}[0]){

		template 'index', {
			'gfe'        => $h_cache{$s_locus}{$s_sequence}[0],
			'structures' => $h_cache{$s_locus}{$s_sequence}[1]
		};

	}else{

        $o_gfe->client(GFE::Client->new(url => $url)) if(defined $url && $url =~ /\S/);
        my $rh_gfe        = $o_gfe->getGfe($s_locus,$s_sequence);

        push(@{$h_cache{$s_locus}{$s_sequence}},$$rh_gfe{gfe});
        push(@{$h_cache{$s_locus}{$s_sequence}},$$rh_gfe{structure});

		template 'index', {
		    'gfe'        => $$rh_gfe{gfe},
		    'structures' => $$rh_gfe{structure}
		};

	}
	

};


=head2 deleteOldFiles

        Title:    deleteOldFiles
        Usage:    
        Function: 
  
=cut
sub deleteOldFiles{

    my $date      = strftime "%m-%d-%Y", localtime;
    my @a_loci    = ("HLA_A", "HLA_B", "HLA_C"); 
    my $g_fasta   = $o_gfe->annotate->outdir."/*.fasta";
    my $g_csv1    = $o_gfe->annotate->directory."/*.csv";
    my $g_csv2    = $o_gfe->annotate->directory."/GFE/parsed-local/*.csv";

    foreach my $s_file (glob("$g_fasta $g_csv")){
        my @a_file = [$s_file, (stat $s_file)[9]];
        my $s_file_created = strftime("%m-%d-%Y", localtime $a_file[0]->[1]);
        if($s_file_created ne $date){
            system("rm $s_file");
        }
    }

    foreach my $s_loc  (@a_loci){
        my $s_clu_dir     = $o_gfe->annotate->directory."/output/clu/".$s_loc."/*.clu";
        my $s_exon_dir    = $o_gfe->annotate->directory."/output/exon/".$s_loc."/*.txt";
        my $s_fasta_dir   = $o_gfe->annotate->directory."/output/fasta/".$s_loc."/*.fasta";
        my $s_protein_dir = $o_gfe->annotate->directory."/output/protein/".$s_loc."/*.fasta";
        foreach my $s_file (glob("$s_clu_dir $s_exon_dir $s_fasta_dir $s_protein_dir")){
            my @a_file = [$s_file, (stat $s_file)[9]];
            my $s_file_created = strftime("%m-%d-%Y", localtime $a_file[0]->[1]);
            if($s_file_created ne $date){
                system("rm $s_file");
            }
        }
    }

}


1;
