package Net::Topsy;
use 5.010;
use Carp qw/croak/;
use Moose;
use URI::Escape;
use JSON::Any qw/XS DWIW JSON/;
use Data::Dumper;
use namespace::autoclean;
use LWP::UserAgent;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

has useragent_class => ( isa => 'Str', is => 'ro', default => 'LWP::UserAgent' );
has useragent_args  => ( isa => 'HashRef', is => 'ro', default => sub { {} } );
has ua              => ( isa => 'Object', is => 'rw' );
has beta_key        => ( isa => 'Str', is => 'rw', required => 1 );
has format          => ( isa => 'Str', is => 'rw', required => 1, default => '.json' );
has base_url        => ( isa => 'Str', is => 'ro', default => 'http://otter.topsy.com' );
has useragent       => ( isa => 'Str', is => 'ro', default => "Net::Topsy/$VERSION (Perl)" );

sub BUILD {
    my $self = shift;
    $self->ua($self->useragent_class->new(%{$self->useragent_args}));
    $self->ua->agent($self->useragent);
}

sub search {
    my ($self, $params) = @_;
    return $self->_search($params, '/search');
}

sub searchcount {
    my ($self, $params) = @_;
    return $self->_search($params, '/searchcount');
}

sub authorsearch {
    my ($self, $params) = @_;
    return $self->_search($params, '/authorsearch');
}

sub profilesearch {
    my ($self, $params) = @_;
    return $self->_search($params, '/profilesearch');
}

sub _search {
    my ($self, $params, $route) = @_;
    my $q      = $params->{q};
    my $window = $params->{window};
    die 'no route to _search!' unless $route;

    croak "Net::Topsy::${route}: q param is necessary" unless $q;

    $route  = $self->base_url . $route . $self->format;

    $q = uri_escape($q);
    my $url      = $route ."?beta=" . $self->beta_key . '&q=' . $q ;
    $url        .= "windows=$window" if defined $window;

    return $self->_handle_response( $self->ua->get( $url ) );
}

sub _url_search {
    my ($self, $params, $route) = @_;
    my $contains = $params->{contains};
    die 'no route to _url_search!' unless $route;

    # XXX: trending doesn't require a url
    #croak "Net::Topsy::${route}: url param is necessary" unless $params->{url};

    $route  = $self->base_url . $route . $self->format;

    my $url   = $route ."?beta=" . $self->beta_key;
    $url     .= '&url=' . uri_escape($params->{url}) if defined $params->{url};
    $url     .= "contains=$contains" if defined $contains;

    return $self->_handle_response( $self->ua->get( $url ) );
}

sub stats {
    my ($self, $params) = @_;
    return $self->_url_search($params, '/stats');
}

sub tags {
    my ($self, $params) = @_;
    return $self->_url_search($params, '/tags');
}

sub authorinfo {
    my ($self, $params) = @_;
    return $self->_url_search($params, '/authorinfo');
}

sub urlinfo {
    my ($self, $params) = @_;
    return $self->_url_search($params, '/urlinfo');
}

sub linkposts {
    my ($self, $params) = @_;
    return $self->_url_search($params, '/linkposts');
}

sub trending {
    my ($self, $params) = @_;
    return $self->_url_search($params, '/trending');
}

sub related {
    my ($self, $params) = @_;
    return $self->_url_search($params, '/related');
}

sub _handle_response {
    my ($self, $response ) = @_;
    if ($response->is_success) {
        my $obj = $self->_from_json( $response->content );
        return $obj;
    } else {
        die $response->status_line;
    }
}

sub _from_json {
    my ($self, $json) = @_;

    return eval { JSON::Any->from_json($json) };
}

=head1 NAME

Net::Topsy - Perl Interface to the Otter API to Topsy

=head1 VERSION

Version 0.01

=cut


=head1 SYNOPSIS

    use Net::Topsy;

    my $topsy  = Net::Topsy->new( { beta => $beta_key } );
    my $search = $topsy->search( { q => 'perl' } );

=head1 METHODS

=item authorinfo

=item authorsearch

=item linkposts

=item profilesearch

=item related

=item stats

=item search

=item searchcount

=item tags

=item trackbacks

=item trending

=item urlinfo

=head1 AUTHOR

Jonathan Leto, C<< <jonathan at leto.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-topsy at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net::Topsy>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I
make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Topsy

For documentation about the Otter API to Topsy.com : L<http://code.google.com/p/otterapi> .

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net::Topsy>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net::Topsy>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net::Topsy>

=item * Search CPAN

L<http://search.cpan.org/dist/Net::Topsy>

=back


=head1 ACKNOWLEDGEMENTS

Many thanks to Marc Mims <marc@questright.com>, the author of Net::Twitter, for the
Mock::LWP::UserAgent module that mocks out LWP::UserAgent for the tests.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Jonathan Leto <jonathan@leto.net>, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;
