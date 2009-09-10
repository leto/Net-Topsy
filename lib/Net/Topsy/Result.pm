package Net::Topsy::Result;
use Moose;
use MooseX::Iterator;
has perl => ( isa => 'HashRef', is => 'rw' );
has json => ( isa => 'Str',     is => 'rw' );
has response => ( isa => 'HTTP::Response', is => 'rw' );

sub BUILD {
    my $self = shift;
    return $self;
}

1;
