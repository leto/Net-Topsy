#!perl
use warnings;
use strict;
use Test::More;
use Data::Dumper;

use lib qw(t/lib);
use Mock::LWP::UserAgent;
use Net::Topsy;

plan tests => 17;

{
    my $nt = Net::Topsy->new( key => 'foo' );
    isa_ok $nt, 'Net::Topsy';
    my $r = $nt->top( { thresh => 'top100' } );
    isa_ok($r,'Net::Topsy::Result');
    my $r = $nt->trending;
    isa_ok($r,'Net::Topsy::Result');
    my $ua = $nt->ua;
    isa_ok($ua, 'LWP::UserAgent');
}

{
    my @api_search_methods = qw/experts search searchcount searchdate searchhistogram/;
    my @api_url_methods = qw/authorinfo linkposts linkpostcount populartrackbacks stats tags trackbacks urlinfo/;

    for my $method (@api_search_methods) {
        my $nt     = Net::Topsy->new( key => 'foo' );
        my $result = $nt->$method( { q => 'lulz' } );
        isa_ok($result,'Net::Topsy::Result');
    }

    for my $method (@api_url_methods) {
        my $nt     = Net::Topsy->new( key => 'foo' );
        my $result = $nt->$method( { url => 'lolz' } );
        isa_ok($result,'Net::Topsy::Result');
    }
}

1;

