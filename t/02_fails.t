#!perl
use warnings;
use strict;
use Test::Exception;
use lib qw(t/lib);
use Mock::LWP::UserAgent;
use Net::Topsy;
use Test::More tests => 2;


throws_ok( sub { my $nt = Net::Topsy->new }, qr/Attribute \(beta_key\) is required/ );

throws_ok( sub { my $ny = Net::Topsy->new( beta_key => undef ) }, qr/Attribute \(beta_key\) does not pass the type constraint/);
1;
