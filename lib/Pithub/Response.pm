package Pithub::Response;

use Moose;
use HTTP::Response;
use namespace::autoclean;

=head1 NAME

Pithub::Response

=head1 ATTRIBUTES

=head2 request

The L<Pithub::Request> object.

=cut

has 'request' => (
    is       => 'ro',
    isa      => 'Pithub::Request',
    required => 1,
);

=head2 http_response

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

=head1 METHODS

=head2 parse_response

Utility method.

=cut

sub parse_response {
    my ( $self, $str ) = @_;
    my $res = HTTP::Response->parse($str);
    $self->http_response($res);
    return $res;
}

__PACKAGE__->meta->make_immutable;

1;
