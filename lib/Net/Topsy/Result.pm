package Net::Topsy::Result;
use Moose;

has perl => ( isa => 'HashRef', is => 'rw' );
has json => ( isa => 'Str',     is => 'rw' );
has response => ( isa => 'HTTP::Response', is => 'rw' );

sub BUILD {
    my $self = shift;
    return $self;
}

1;
