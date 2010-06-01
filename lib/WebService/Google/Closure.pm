package WebService::Google::Closure;

use Moose;
use MooseX::Types::Moose qw( ArrayRef Str Int );
use LWP::UserAgent;
use Carp qw( croak );

use WebService::Google::Closure::Types qw( ArrayRefOfStrings CompilationLevel );
use WebService::Google::Closure::Response;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

has js_code => (
    is         => 'rw',
    isa        => Str,
);

has file => (
    is         => 'ro',
    isa        => ArrayRefOfStrings,
    trigger    => \&_set_file,
    coerce     => 1,
);

has code_url => (
    is         => 'ro',
    isa        => ArrayRefOfStrings,
    init_arg   => 'url',
    coerce     => 1,
);

has compilation_level => (
    is         => 'ro',
    isa        => CompilationLevel,
    coerce     => 1,
);

has timeout => (
    is         => 'ro',
    isa        => Int,
    default    => 10,
);

has post_url => (
    is         => 'ro',
    isa        => Str,
    default    => 'http://closure-compiler.appspot.com/compile',
    init_arg   => undef,
);

has output_format => (
    is         => 'ro',
    isa        => Str,
    default    => 'json',
    init_arg   => undef,
);

has output_info => (
    is         => 'ro',
    isa        => ArrayRef[Str],
    init_arg   => undef,
    lazy_build => 1,
);

has ua => (
    is         => 'ro',
    init_arg   => undef,
    lazy_build => 1,
);

sub _set_file {
    my $self = shift;
    my $content = '';
    foreach my $f ( @{ $self->file } ) {
        open (my $fh, "<", $f) or die "Can't read file: $f";
        local $/;
        $content .= <$fh>;
        close ($fh);
    }
    $self->js_code( $content );
}

sub _build_ua {
    my $self = shift;
    my $ua = LWP::UserAgent->new;
    $ua->timeout( $self->timeout );
    $ua->env_proxy;
    $ua->agent( __PACKAGE__ . '/' . $VERSION );
    return $ua;
}

sub _build_output_info {
    return [ qw( compiled_code statistics warnings errors ) ];
}

sub compile {
    my $self = shift;

    my $post_args = {};
    foreach my $arg (qw( js_code code_url compilation_level output_format output_info )) {
        next unless $self->$arg;
        $post_args->{ $arg } = $self->$arg;
    }

    my $res = $self->ua->post(
        $self->post_url, $post_args
    );
    unless ( $res->is_success ) {
        croak "Error posting request to Google - " . $res->status_line;
    }

    return WebService::Google::Closure::Response->new(
        format  => $self->output_format,
        content => $res->content,
    );
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__


=head1 NAME

WebService::Google::Closure - Perl interface to the Google Closure Javascript compiler service

=head1 SYNOPSIS

This module will take given Javascript code and compile it into compact, high-performance code
using the Google Closure compiler.

    use WebService::Google::Closure;

    my $js_code = "
      function hello(name) {
          alert('Hello, ' + name);
      }
      hello('New user');
    ";

    my $res = WebService::Google::Closure->new(
      js_code => $js_code,
    )->compile;

    print $res->code;
    # prints;
    # function hello(a){alert("Hello, "+a)}hello("New user");


    # Now tell Closure to be more aggressive
    my $res2 = WebService::Google::Closure->new(
      compilation_level => "ADVANCED_OPTIMIZATIONS",
      js_code => $js_code,
    )->compile;

    print $res2->code;
    # prints;
    # alert("Hello, New user");

    print "Original size   = " . $res2->stats->original_size . "\n";
    print "Compressed size = " . $res2->stats->compressed_size . "\n";


For more information about the Google Closure compile, visit its website at
 http://code.google.com/closure/

=head1 METHODS

=head2 new

Possible options;

=over 4

=item

=head2 compile

Returns a L<WebService::Google::Closure::Response> object.

Will die if unable to connect to the Google closure service.

=head1 AUTHOR

Magnus Erixzon, C<< <magnus at erixzon.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-google-closure at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Google-Closure>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::Google::Closure

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-Google-Closure>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-Google-Closure>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-Google-Closure>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-Google-Closure/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Magnus Erixzon.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
