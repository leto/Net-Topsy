#!perl

use warnings;
use strict;
use Test::More;

BEGIN {
    use_ok( 'Net::Topsy' );
}

diag( "Testing Net::Topsy $Net::Topsy::VERSION, Perl $], $^X" );

done_testing;
