package Net::Topsy::Role::API;  # modeled after http://code.google.com/p/otterapi/wiki/Resources

use Moose::Role;

my %list_parameters = (
    page    => 0,
    perpage => 0,
    offset  => 0,
    mintime => 0,
    maxtime => 0,
    nohidden => 0,
    allow_lang => 0,
    family_filter => 0,
);

has API => ( isa => 'HashRef', is => 'ro', default => sub {
        {
        'http://otter.topsy.com' => {
            '/authorinfo' => {
                args       => {
                    url       => 1,
                },
            },
            '/experts' => {
                args       => {
                    q       => 1,
                    config_NoFilters  => 0,
                    %list_parameters
                },
            },
            '/linkposts' => {
                args       => {
                    url       => 1,
                    contains => 0,
                    tracktype => 0,
                    %list_parameters
                },
            },
            '/linkpostcount' => {
                args       => {
                    url       => 1,
                    contains => 0,
                    tracktype => 0,
                },
            },
            '/populartrackbacks' => {
                args       => {
                    url       => 1,
                    %list_parameters
                },
            },
            '/search' => {
                args       => {
                    q       => 1,
                    window  => 0,
                    type    => 0,
                    query_features => 0,
                    %list_parameters
                },
            },
            '/searchcount' => {
                args       => {
                    q      => 1,
                    dynamic => 0,
                },
            },
            '/searchhistogram' => {
                args       => {
                    q       => 1,
                    slice   => 0,
                    period  => 0,
                    count_method    => 0,
                },
            },
            '/searchdate' => {
                args       => {
                    q       => 1,
                    window  => 0,
                    type    => 0,
                    zoom    => 0,
                },
            },
            '/stats' => {
                args       => {
                    url       => 1,
                    contains  => 0,
                },
            },
            '/top' => {
                args       => {
                    thresh    => 1,
                    type      => 0,
                    locale    => 0,
                    %list_parameters
                },
            },
            '/tags' => {
                args       => {
                    url       => 1,
                    %list_parameters
                },
            },
            '/trackbacks' => {
                args       => {
                    url      => 1,
                    contains => 0,
                    infonly  => 0,
                    sort_method  => 0,
                    %list_parameters
                },
            },
            '/trending' => {
                args       => {
                    %list_parameters
                },
            },
            '/urlinfo' => {
                args       => {
                    url       => 1,
                },
            },
        },
    },
});

1;
