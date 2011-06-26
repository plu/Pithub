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

has 'first_page_uri' => (
    is         => 'ro',
    isa        => 'Str|Undef',
    lazy_build => 1,
);

has 'last_page_uri' => (
    is         => 'ro',
    isa        => 'Str|Undef',
    lazy_build => 1,
);

has 'next_page_uri' => (
    is         => 'ro',
    isa        => 'Str|Undef',
    lazy_build => 1,
);

has 'prev_page_uri' => (
    is         => 'ro',
    isa        => 'Str|Undef',
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

sub _build_first_page_uri {
    return shift->_get_link_header('first');
}

sub _build_last_page_uri {
    return shift->_get_link_header('last');
}

sub _build_next_page_uri {
    return shift->_get_link_header('next');
}

sub _build_prev_page_uri {
    return shift->_get_link_header('prev');
}

sub _build__json {
    my ($self) = @_;
    return JSON::Any->new;
}

sub _get_link_header {
    my ( $self, $type ) = @_;
    return $self->{_get_link_header}{$type} if $self->{_get_link_header}{$type};
    my $link = $self->response->http_response->header('Link');
    foreach my $item ( split /,/, $link ) {
        my @result = $item =~ /<([^>]+)>; rel="([^"]+)"/g;
        $self->{_get_link_header}{ $result[1] } = $result[0];
    }
    return $self->{_get_link_header}{$type};
}

__PACKAGE__->meta->make_immutable;

1;
