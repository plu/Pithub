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

=attr http_response

The L<HTTP::Response> object. There are following delegate methods
installed for convenience:

=over

=item *

B<code>: http_response->code

=item *

B<content>: http_response->content

=item *

B<success>: http_response->is_cuess

=back

=cut

has 'http_response' => (
    handles => {
        code    => 'code',
        content => 'content',
        success => 'is_success',
    },
    is       => 'rw',
    isa      => 'HTTP::Response',
    required => 0,
);

__PACKAGE__->meta->make_immutable;

1;
