#!/usr/bin/env perl
use strict;
use warnings;
use Net::Topsy;
use Data::Dumper;
my $search_term = shift || 'perl';

=head1 SYNOPSIS

TOPSY_API_KEY=somekey perl -Ilib examples/search.pl search_term

Shows the top 30 matches for today.

=cut

my $topsy = Net::Topsy->new( key => $ENV{TOPSY_API_KEY} );
my $search = $topsy->search({
                               q => $search_term,
                               page   =>  1,  # default
                               perpage => 30, # 30 per page
                               window => 'd', # today
                            });
my $topics = $search->{response}{list};

for my $topic (@$topics) {
    printf "%-60s : %d : %s\n", $topic->{title} ,$topic->{hits}, $topic->{url};
}
