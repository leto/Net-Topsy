use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Net::Topsy',
    license             => 'perl',
    dist_author         => 'Jonathan Leto <jonathan@leto.net>',
    dist_abstract       => 'Perl Interface to the Otter API to Topsy',
    dist_version_from   => 'lib/Net/Topsy.pm',
    build_requires => {
        'Test::More'      => 0,
        'Test::Exception' => 0,
    },
    requires => {
        'Moose'          => 0.78,
        'JSON::Any'      => 1.19,
        'URI::Escape'    => 0,
        'LWP::UserAgent' => 2.032,
    },
    add_to_cleanup      => [ 'Net::Topsy-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
