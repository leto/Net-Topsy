#!perl
use warnings;
use strict;
use Test::More;
use Data::Dumper;
use Net::Topsy;

use lib qw(t/lib);

use Mock::LWP::UserAgent;

plan tests => 2;


my $nt = Net::Topsy->new( beta_key => 'foo' );
isa_ok $nt, 'Net::Topsy';

my $ua = $nt->ua;

my $result = $nt->search( { q => 'barack obama' } );

ok($result, 'got a result from search' );


1;
