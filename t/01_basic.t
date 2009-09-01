#!perl
use warnings;
use strict;
use Test::More;
use Data::Dumper;

use lib qw(t/lib);
use Mock::LWP::UserAgent;

use Net::Topsy;

plan tests => 5;

my $nt = Net::Topsy->new( beta_key => 'foo' );
isa_ok $nt, 'Net::Topsy';

my $ua = $nt->ua;

{
    my $result = $nt->search( { q => 'barack obama' } );
    ok($result, 'got a result from search' );
}
{
    my $result = $nt->searchcount( { q => 'barack obama' } );
    ok($result, 'got a result from searchcount' );
}
{
    my $result = $nt->profilesearch( { q => 'barack obama' } );
    ok($result, 'got a result from profilesearch' );
}
{
    my $result = $nt->authorsearch( { q => 'barack obama' } );
    ok($result, 'got a result from authorsearch' );
}

1;
