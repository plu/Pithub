package Pithub::Result;

use Moose;
use JSON::Any;
use namespace::autoclean;

=head1 NAME

Pithub::Result

=cut

has 'content' => (
    is         => 'ro',
    isa        => 'HashRef|ArrayRef',
    lazy_build => 1,
);

has 'response' => (
    handles => {
        code                => 'code',
        ratelimit           => 'ratelimit',
        ratelimit_remaining => 'ratelimit_remaining',
        raw_content         => 'content',
        request             => 'request',
        success             => 'success',
    },
    is       => 'ro',
    isa      => 'Pithub::Response',
    required => 1,
);

has '_json' => (
    is         => 'ro',
    isa        => 'JSON::Any',
    lazy_build => 1,
);

sub _build_content {
    my ($self) = @_;
    if ( $self->raw_content ) {
        return $self->_json->decode( $self->raw_content );
    }
    return {};
}

sub _build__json {
    my ($self) = @_;
    return JSON::Any->new;
}

__PACKAGE__->meta->make_immutable;

1;
