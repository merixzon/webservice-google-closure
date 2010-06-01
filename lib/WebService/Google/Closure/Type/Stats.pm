package WebService::Google::Closure::Type::Stats;

use Moose;
use MooseX::Types::Moose qw( Str Int );

has original_size => (
    is         => 'ro',
    isa        => Int,
    init_arg   => 'originalSize',
    required   => 1,
);

has compressed_size => (
    is         => 'ro',
    isa        => Int,
    init_arg   => 'compressedSize',
    required   => 1,
);

has original_gzip_size => (
    is         => 'ro',
    isa        => Int,
    init_arg   => 'originalGzipSize',
    required   => 1,
);

has compressed_gzip_size => (
    is         => 'ro',
    isa        => Int,
    init_arg   => 'compressedGzipSize',
    required   => 1,
);

has compile_time => (
    is         => 'ro',
    isa        => Int,
    init_arg   => 'compileTime',
    required   => 1,
);


no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
