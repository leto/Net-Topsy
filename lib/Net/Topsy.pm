package Net::Topsy;
use 5.010;
use Carp qw/croak/;
use Moose;
use URI::Escape;
use JSON::Any qw/XS DWIW JSON/;
use Data::Dumper;
use namespace::autoclean;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

has useragent_class => ( isa => 'Str', is => 'ro', default => 'LWP::UserAgent' );
has useragent_args  => ( isa => 'HashRef', is => 'ro', default => sub { {} } );
has ua              => ( isa => 'Object', is => 'rw' );
has beta_key        => ( isa => 'Str', is => 'rw', required => 1 );
has base_url        => ( isa => 'Str', is => 'ro', default => 'http://otter.topsy.com' );

has useragent       => ( isa => 'Str', is => 'ro', default => "Net::Topsy/$VERSION (Perl)" );

sub BUILD {
    my $self = shift;
    $self->ua($self->useragent_class->new(%{$self->useragent_args}));
    $self->ua->agent($self->useragent);
}

sub search {
    my ($self, $params) = @_;
    my $q = $params->{q};
    croak "Net::Topsy::search: q param is necessary" unless $q;

    my $response = $self->ua->get( $self->base_url . '/search.json?q=' . $q );
    if ($response->is_success) {
        #warn "got success!";
        #warn Dumper [ $response ];
        #warn Dumper [ $response->content ];
        my $obj = $self->_from_json( $response->content );
        return $obj;
    } else {
        #warn "got fail!";
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

    my $topsy = Net::Topsy->new( { beta => $beta_key } );

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


=head1 COPYRIGHT & LICENSE

Copyright 2009 Jonathan Leto, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;
