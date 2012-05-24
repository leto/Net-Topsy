#!perl
use warnings;
use strict;
use Test::Exception;
use lib qw(t/lib);
use Mock::LWP::UserAgent;
use Net::Topsy;
use Test::More tests => 16;
use Test::Warn;

my @api_search_methods = qw/experts search searchcount searchdate searchhistogram/;
my @api_url_methods = qw/authorinfo linkposts linkpostcount populartrackbacks stats tags trackbacks urlinfo/;
my @link_methods = qw/top trending/;

my $nt = Net::Topsy->new( key => 'foo' );

throws_ok( sub { my $nt = Net::Topsy->new( key => undef ) },
           qr/Attribute \(key\) does not pass the type constraint/,
);

for my $method (@api_search_methods) {
    throws_ok( sub {
            $nt->$method( { } );
        },
        qr/$method -> required params missing: q/,
    );
}

for my $method (@api_url_methods) {
    throws_ok( sub {
            $nt->$method( { } );
        },
        qr/$method -> required params missing: url/,
    );
}

for my $method (@link_methods) {
    warnings_like( sub {
            $nt->$method( { thresh => 'top100', q => 'foo' } );
        },
        qr/unexpected params: q/,
    );
}

