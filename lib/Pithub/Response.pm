package Pithub::Response;

# ABSTRACT: Github v3 response object

use Moose;
use HTTP::Response;
use namespace::autoclean;

=attr request

The L<Pithub::Request> object.

=cut

has 'request' => (
    is       => 'ro',
    isa      => 'Pithub::Request',
    required => 1,
);

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

=cut

sub _build_http_response {
    return shift->request->send;
}

__PACKAGE__->meta->make_immutable;

1;
