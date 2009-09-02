#!perl
use warnings;
use strict;
use Test::More;
use Data::Dumper;

use lib qw(t/lib);
use Mock::LWP::UserAgent;

use Net::Topsy;

plan tests => 12;

my $nt = Net::Topsy->new( beta_key => 'foo' );
isa_ok $nt, 'Net::Topsy';

my $ua = $nt->ua;

my @api_search_methods = qw/search searchcount profilesearch authorsearch/;
my @api_url_methods = qw/trackbacks tags stats authorinfo urlinfo linkposts related/;

for my $method (@api_search_methods) {
    my $result = $nt->$method( { q => 'lulz' } );
    ok($result, "got a result from $method" );
}

for my $method (@api_url_methods) {
    my $result = $nt->$method( { url => 'lolz' } );
    ok($result, "got a result from $method" );
}

1;
