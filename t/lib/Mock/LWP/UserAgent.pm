package # hide from PAUSE
    Mock::LWP::UserAgent;

$INC{'LWP/UserAgent.pm'} = __FILE__;

package # hide from PAUSE
    LWP::UserAgent;

use HTTP::Response;
use warnings;
use strict;
use URI;

my %_api = (
    'otter.topsy.com' => {
        '/search' => {
            args       => {
            q       => 1,
            windows => 0,
            },
        },
   },
);

my %topsy_api;
while ( my($host, $api) = each %_api ) {
    while ( my($path, $entry) = each %$api ) {
        if ( my $existing = $topsy_api{$path} ) {
            die "duplicate $path in $existing->{host} and $host";
        }
        $topsy_api{$path} = { %$entry, host => $host };
    }
}

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub credentials {}

sub agent {}

sub default_header {}

sub env_proxy {}

sub get {
    my ($self, $url) = @_;

    my $uri = URI->new($url);
    $self->{_input_uri} = $uri->clone; # stash for tests
    $self->{_input_method} = 'GET';
    eval { $self->_validate_basic_url($uri) };
    chomp $@, return $self->_error_response(400, $@) if $@;

    # strip the args
    my %args = $uri->query_form;
    $uri->query_form([]);

    return $self->_topsy_rest_api('GET', $uri, \%args);
}

sub post {
    my ($self, $url, $args) = @_;

    my $uri = URI->new($url);
    $self->{_input_uri} = $uri->clone; # stash for tests
    $self->{_input_method} = 'POST';
    eval { $self->_validate_basic_url($uri) };
    chomp $@, return $self->_error_response(400, $@) if $@;

    return $self->_error_response(400, "POST $url contains parameters") if $uri->query_form;
    return $self->_topsy_rest_api('POST', $uri, $args);
}

sub _topsy_rest_api {
    my ($self, $method, $uri, $args) = @_;

    my ($path, $id) = eval { $self->_parse_path_id($uri) };

    chomp $@, return $self->_error_response(400, $@) if $@;

    return $self->_error_response(400, "Bad URL, /ID.json present.") if $uri =~ m/ID.json/;

    my $api_entry = $topsy_api{$path}
        || return $self->error_response(404, "$path is not a topsy api entry");

    my $host = $uri->host;
    return $self->_error_response(400, "expected $api_entry->{host}, got $host")
        unless $host = $api_entry->{host};

    # TODO: What if ID is passed in the URL and args? What if the 2 are different?
    $args->{id} = $id if $api_entry->{has_id} && defined $id && $id;

    $self->{_input_args} = { %$args }; # save a copy of input args for tests

    return $self->_error_response(400, "expected POST")
        if  $api_entry->{post} && $method ne 'POST';
    return $self->_error_response(400, "expected GET")
        if !$api_entry->{post} && $method ne 'GET';

    if ( my $coderef = $api_entry->{required} ) {
        unless ( $coderef->($args) ) {
            return $self->_error_response(400, "requried args test failed");
        }
    }
    else {
        my @required = grep { $api_entry->{args}{$_} } keys %{$api_entry->{args}};
        if ( my @missing = grep { !exists $args->{$_} } @required ) {
            return $self->_error_response(400, "$path -> requried args missing: @missing");
        }
    }

    if ( my @undefined = grep { $args->{$_} eq '' } keys %$args ) {
        return $self->_error_response(400, "args with undefined values: @undefined");
    }

    my %unexpected_args = map { $_ => 1 } keys %$args;
    delete $unexpected_args{$_} for keys %{$api_entry->{args}};
    if ( my @unexpected_args = sort keys %unexpected_args ) {
        # topsy seems to ignore unexpected args, so don't fail, just diag
        print "# unexpected args: @unexpected_args\n" if $self->print_diags;
    }

    return $self->_response;
}

sub _validate_basic_url {
    my ($self, $url) = @_;

    my $uri = URI->new($url);

    die "scheme: expected http\n" unless $uri->scheme eq 'http';
    die "expected .json\n" unless (my $path = $uri->path) =~ s/\.json$//;

    $uri->path($path);
}

sub _error_response {
    my ($self, $rc, $msg) = @_;

    print "# $msg\n" if $self->print_diags;
    return $self->_response(_rc => $rc, _msg => $msg, _content => $msg);
}

sub _response {
    my ($self, %args) = @_;

    bless {
        _content => $self->{_res_content} || '{"test":"1"}',
        _rc      => $self->{_res_code   } || 200,
        _msg     => $self->{_res_message} || 'OK',
        _headers => {},
        %args,
    }, 'HTTP::Response';
}

sub _parse_path_id {
    my ($self, $uri) = @_;

    (my $path = $uri->path) =~ s/\.json$//;
    return ($path) if $topsy_api{$path};

    my ($ppath, $id) = $path =~ /(.*)\/(.*)$/;

    return ($ppath, $id) if $topsy_api{$ppath} && $topsy_api{$ppath}{has_id};

    die "$path is not a topsy_api method\n";
}

sub print_diags {
    my $self = shift;

    return $self->{_print_diags} unless @_;
    $self->{_print_diags} = shift;
}

sub input_args {
    my $self = shift;

    return $self->{_input_args} || {};
}

sub input_uri { shift->{_input_uri} }

sub input_method { shift->{_input_method} }

sub set_response {
    my ($self, $args) = @_;

    @{$self}{qw/_res_code _res_message _res_content/} = @{$args}{qw/code message content/};
    ref $args->{content}
        && ( $self->{_res_content} = eval { JSON::Any->to_json($args->{content}) } )
        || ref $args->{content};
}

sub clear_response { delete @{shift()}{qw/_res_code _res_message _re_content/} }

1;
