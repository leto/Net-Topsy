#!/usr/bin/env perl
use strict;
use warnings;
use Net::Topsy;
use Data::Dumper;

=head1 SYNOPSIS

TOPSY_API_KEY=somekey perl -Ilib examples/trending.pl

=cut

my $topsy = Net::Topsy->new( key => $ENV{TOPSY_API_KEY} );
my $search = $topsy->trending;
my $topics = $search->{response}{list};

for my $topic (@$topics) {
    printf "%-20s\t:\t%s\n", $topic->{term} , $topic->{url};
}
