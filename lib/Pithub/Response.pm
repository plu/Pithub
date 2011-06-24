package Pithub::Response;

use Moose;
use HTTP::Response;
use namespace::autoclean;

=head1 NAME

Pithub::Response

=cut

has 'request' => (
    is       => 'ro',
    isa      => 'Pithub::Request',
    required => 1,
);

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

sub parse_response {
    my ( $self, $str ) = @_;
    my $res = HTTP::Response->parse($str);
    $self->http_response($res);
    return $res;
}

sub ratelimit {
    my ($self) = @_;
    return $self->http_response->header('X-RateLimit-Limit');
}

sub ratelimit_remaining {
    my ($self) = @_;
    return $self->http_response->header('X-RateLimit-Remaining');
}

__PACKAGE__->meta->make_immutable;

1;
