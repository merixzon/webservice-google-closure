package WebService::Google::Closure::Response;

use Moose;
use MooseX::Types::Moose qw( ArrayRef Str Int );
use JSON;

use WebService::Google::Closure::Types qw( ArrayRefOfWarnings ArrayRefOfErrors Stats );

has format => (
    is         => 'ro',
    isa        => Str,
    trigger    => sub { my $self = shift; die "Bad format - only json" unless $self->format eq 'json' },
);

has content => (
    is         => 'ro',
    isa        => Str,
    trigger    => \&_set_content,
);

has code => (
    is         => 'ro',
    isa        => Str,
    init_arg   => undef,
    predicate  => 'has_code',
    writer     => '_set_compiledCode',
);

has warnings => (
    is         => 'ro',
    isa        => ArrayRefOfWarnings,
    init_arg   => undef,
    predicate  => 'has_warnings',
    writer     => '_set_warnings',
    coerce     => 1,
);

has errors => (
    is         => 'ro',
    isa        => ArrayRefOfErrors,
    init_arg   => undef,
    predicate  => 'has_errors',
    writer     => '_set_errors',
    coerce     => 1,
);

has stats => (
    is         => 'ro',
    isa        => Stats,
    init_arg   => undef,
    predicate  => 'has_stats',
    writer     => '_set_statistics',
    coerce     => 1,
);

has is_success => (
    is         => 'ro',
    lazy_build => 1,
);

sub _build_is_success {
    my $self = shift;
    if ( $self->has_errors ) {
        return 0;
    }
    return 1;
}

sub _set_content {
    my $self = shift;

    my $content = from_json( $self->content );
    foreach my $key ( keys %{ $content } ) {
        next unless $content->{ $key };
        my $set = '_set_' . $key;
        $self->$set( $content->{ $key } );
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
