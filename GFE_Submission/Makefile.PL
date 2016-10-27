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
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Moose'      => 0,
        'Dancer'     => 1.3142,
        'JSON'       => 0,
        'Dancer::Plugin::Swagger' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'GFE_Submission-*' },
);
