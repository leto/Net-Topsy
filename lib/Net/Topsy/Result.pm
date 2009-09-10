use MooseX::Declare;

class Net::Topsy::Result {
    use MooseX::Iterator;
    use namespace::clean;

    has perl     => ( isa => 'HashRef', is => 'rw' );
    has json     => ( isa => 'Str',     is => 'rw' );
    has response => ( isa => 'HTTP::Response', is => 'rw' );

    method BUILD {
        return $self;
    }
}

1;
