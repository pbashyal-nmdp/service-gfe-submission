use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on them.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'GFE_Client',
    AUTHOR              => q{Mike Halagan <mhalagan@nmdp.org>},
    VERSION_FROM        => 'lib/GFE_Client.pm',
    ABSTRACT            => 'GFE_Client',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3134,
    },
    EXE_FILES    => [ 'bin/gfe-submission' ],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'GFE_Client-*' },
);
