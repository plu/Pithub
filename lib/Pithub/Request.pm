package Pithub::Request;

use Moose;
use MooseX::Types::URI qw(Uri);
use HTTP::Headers;
use HTTP::Request;
use JSON::Any;
use LWP::UserAgent;
use URI;
use namespace::autoclean;

=head1 NAME

Pithub::Request

=cut

has 'data' => (
    is        => 'ro',
    isa       => 'HashRef|ArrayRef|Str',
    predicate => 'has_data',
    required  => 0,
);

has 'http_request' => (
    is         => 'ro',
    isa        => 'HTTP::Request',
    lazy_build => 1,
);

has 'method' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'token' => (
    clearer   => 'clear_token',
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_token',
    required  => 0,
);

has 'ua' => (
    is         => 'ro',
    isa        => 'LWP::UserAgent',
    lazy_build => 1,
);

has 'uri' => (
    coerce   => 1,
    is       => 'ro',
    isa      => Uri,
    required => 1,
);

has '_json' => (
    is         => 'ro',
    isa        => 'JSON::Any',
    lazy_build => 1,
);

sub _build__json {
    my ($self) = @_;
    return JSON::Any->new;
}

sub _build_ua {
    my ($self) = @_;
    return LWP::UserAgent->new;
}

sub _build_http_request {
    my ($self) = @_;

    my $headers = HTTP::Headers->new;

    if ( $self->has_token ) {
        $headers->header( 'Authorization' => sprintf( 'token %s', $self->token ) );
    }

    my $request = HTTP::Request->new( $self->method, $self->uri, $headers );

    if ( $self->has_data ) {
        my $json = $self->_json->encode( $self->data );
        $request->content($json);
    }

    return $request;
}

sub send {
    my ($self) = @_;
    return $self->ua->request( $self->http_request );
}

__PACKAGE__->meta->make_immutable;

1;
