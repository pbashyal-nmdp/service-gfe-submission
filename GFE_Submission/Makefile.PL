=head1 NAME
 
Makefile.PL

=head1 AUTHOR     Mike Halagan <mhalagan@nmdp.org>
    
    Bioinformatics Scientist
    3001 Broadway Stree NE
    Minneapolis, MN 55413
    ext. 8225

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
        'Test::More' => 0,
        'YAML'       => 0,
        'Moose'      => 0,
        'Dancer'     => 1.3202,
        'JSON'       => 0,
        'Dancer::Plugin::Swagger' => 0,
        'Log::Log4perl' => 0,
        'JSON::Schema::AsType' => 0,
        'Plack::Handler::Starman' => 0,
        'Plack'       => 0,
        'Template'      => 0,
        'Getopt::Long'     => 1.3142,
        'LWP::UserAgent'       => 0,
        'Dancer::Plugin::Swagger' => 0,
        'Net::SSLeay' => 0,
        'JSON::Schema::AsType' => 0,
        'IO::Socket::SSL' => 0,
        'REST::Client' => 0,
        'Math::Round' => 0,
        'File::Spec' => 0,
        'XML::DOM' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'GFE_Submission-*' },
);
