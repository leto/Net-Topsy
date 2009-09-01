#!/usr/bin/env perl
use strict;
use warnings;
use Net::Topsy;
use Data::Dumper;

my $topsy = Net::Topsy->new( beta_key => $ENV{TOPSY_API_KEY} );
my $search = $topsy->trending;
warn Dumper [ $search ];
