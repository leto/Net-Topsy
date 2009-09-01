#!perl
use warnings;
use strict;
use Test::Exception;
use lib qw(t/lib);
use Mock::LWP::UserAgent;
use Net::Topsy;
use Test::More tests => 1;


throws_ok( sub { my $nt = Net::Topsy->new }, qr/Attribute \(beta_key\) is required/ );

1;
