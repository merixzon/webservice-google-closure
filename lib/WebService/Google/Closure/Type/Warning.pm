package WebService::Google::Closure::Type::Warning;

use Moose;
use MooseX::Types::Moose qw( Str Int );

has type => (
    is         => 'ro',
    isa        => Str,
    required   => 1,
);

has file => (
    is         => 'ro',
    isa        => Str,
    required   => 1,
);

has lineno => (
    is         => 'ro',
    isa        => Int,
    required   => 1,
);

has charno => (
    is         => 'ro',
    isa        => Int,
    required   => 1,
);

has text => (
    is         => 'ro',
    isa        => Str,
    init_arg   => 'warning',
    required   => 1,
);

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
