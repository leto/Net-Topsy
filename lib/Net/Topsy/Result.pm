use MooseX::Declare;

class Net::Topsy::Result {
    use MooseX::Iterator;
    use namespace::clean;

    has perl     => ( isa => 'HashRef', is => 'rw' );
    has json     => ( isa => 'Str',     is => 'rw' );
    has response => ( isa => 'HTTP::Response', is => 'rw' );
    has _list    => ( isa => 'ArrayRef', is => 'rw', default => sub { [ ] } );
    has iter => (
        metaclass    => 'Iterable',
        iterate_over => '_list',
    );

    method BUILD {
        $self->_list( @{$self->perl->{response}{list}} );
        return $self;
    }
}

1;
