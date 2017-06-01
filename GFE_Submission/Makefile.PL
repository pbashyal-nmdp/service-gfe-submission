=head1 NAME
 
Makefile.PL

=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

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

=cut
use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on them.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'GFE_Submission',
    AUTHOR              => q{Mike Halagan <mhalagan@nmdp.org>},
    VERSION_FROM        => 'lib/GFE_Submission.pm',
    ABSTRACT            => 'RESTful Service getting GFE results from raw sequence data',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 1.302075,
        'YAML'       => 1.21,
        'Moose'      => 2.2004,
        'Dancer'     => 1.3202,
        'JSON'       => 2.90,
        'Dancer::Plugin::Swagger' => 0.2.0,
        'Log::Log4perl' => 1.48,
        'JSON::Schema::AsType' => 0.1.0,
        'Plack::Handler::Starman' => 0,
        'Plack'       => 1.0042,
        'Template'      => 2.26,
        'Getopt::Long'     => 1.3142,
        'LWP::UserAgent'       => 6.17,
        'Dancer::Plugin::Swagger' => 0.2.0,
        'Net::SSLeay' => 1.58,
        'JSON::Schema::AsType' => 0.1.0,
        'IO::Socket::SSL' => 2.044,
        'REST::Client' => 273,
        'Math::Round' => 0.07,
        'File::Spec' => 3.40,
        'XML::DOM' => 1.46,
        'Try::Tiny' => 0.28
    },
    dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean        => { FILES => 'GFE_Submission-*' },
);
