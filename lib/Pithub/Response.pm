package Pithub::Response;

# ABSTRACT: Github v3 response object

use Moose;
use HTTP::Response;
use namespace::autoclean;

=attr http_request

The L<HTTP::Request> object.

=cut

has 'http_request' => (
    is       => 'ro',
    isa      => 'HTTP::Request',
    required => 1,
);

=attr http_response

The L<HTTP::Response> object.

=cut

has 'http_response' => (
    handles => {
        header  => 'header',
        code    => 'code',
        content => 'content',
        success => 'is_success',
    },
    is         => 'rw',
    isa        => 'HTTP::Response',
    lazy_build => 1,
    required   => 0,
);

has 'ua' => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

=head1 METHODS

There are currently following methods, which delegate directly to
methods of L<HTTP::Response>:

=over

=item *

B<header>: L<HTTP::Response>->header

=item *

B<code>: L<HTTP::Response>->code

=item *

B<content>: L<HTTP::Response>->content

=item *

B<success>: L<HTTP::Response>->is_success

=back

If you need access to something else, you can directly access the
L<HTTP::Response> object via the L</http_response> attribute.

=cut

sub _build_http_response {
    my ($self) = @_;
    return $self->ua->request( $self->http_request );
}

__PACKAGE__->meta->make_immutable;

1;
