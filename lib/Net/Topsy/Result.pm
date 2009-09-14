use MooseX::Declare;

class Net::Topsy::Result {
    use MooseX::Iterator;
    use Data::Dumper;
    use namespace::autoclean;

    # Result attributes
    has perl     => ( isa => 'HashRef',        is => 'rw', default => sub { [ ] } );
    has json     => ( isa => 'Str',            is => 'rw', default => '' );
    has response => ( isa => 'HTTP::Response', is => 'rw' );

    # properties of result that Topsy sends us
    has page     => ( isa => 'Int',      is => 'rw', default => 0 );
    has window   => ( isa => 'Str',      is => 'rw', default => '' );
    has total    => ( isa => 'Int',      is => 'rw', default => 0 );
    has perpage  => ( isa => 'Int',      is => 'rw', default => 10);
    has list     => ( isa => 'ArrayRef', is => 'rw', default => sub { [ ] } );

    has iter     => (
        metaclass    => 'Iterable',
        iterate_over => 'list',
    );

    method BUILD {
        for my $attr (qw/page window total list perpage/) {
            $self->$attr( $self->perl->{response}{$attr} );
        }
        return $self;
    }
}

1;
