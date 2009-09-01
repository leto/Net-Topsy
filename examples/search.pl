#!/usr/bin/env perl
use strict;
use warnings;
use Net::Topsy;
use Data::Dumper;
my $search_term = shift || 'perl';

my $topsy = Net::Topsy->new( beta_key => $ENV{TOPSY_API_KEY} );
my $search = $topsy->search( { q => $search_term } );
warn Dumper [ $search ];
