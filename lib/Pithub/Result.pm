package Pithub::Result;

use Moose;
use JSON::Any;
use URI;
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
        code        => 'code',
        raw_content => 'content',
        request     => 'request',
        success     => 'success',
    },
    is       => 'ro',
    isa      => 'Pithub::Response',
    required => 1,
);

# required for next_page etc
has '_request' => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

has '_json' => (
    is         => 'ro',
    isa        => 'JSON::Any',
    lazy_build => 1,
);

=head1 METHODS

=head2 first_page

Get the L<Pithub::Result> of the first page. Returns undef if there
is no first page (if you're on the first page already or if there
is no pages at all).

=cut

sub first_page {
    my ($self) = @_;
    return unless $self->first_page_uri;
    return $self->_paginate( $self->first_page_uri );
}

=head2 last_page

Get the L<Pithub::Result> of the last page. Returns undef if there
is no last page (if you're on the last page already or if there
is only one page or no pages at all).

=cut

sub last_page {
    my ($self) = @_;
    return unless $self->last_page_uri;
    return $self->_paginate( $self->last_page_uri );
}

=head2 next_page

Get the L<Pithub::Result> of the next page. Returns undef if there
is no next page (there's only one page at all).

Examples:

=over

=item *

List all followers in order, from the first one on the first
page to the last one on the last page.

    $followers = Pithub->new->users->followers;
    $result = $followers->list( user => 'rjbs' );
    do {
        if ( $result->success ) {
            foreach my $row ( @{ $result->content } ) {
                printf "%s\n", $row->{login};
            }
        }
    } while $result = $result->next_page;

The nature of the implementation requires you here to do a
C<< do { ... } while ... >> loop.

=back

=cut

sub next_page {
    my ($self) = @_;
    return unless $self->next_page_uri;
    return $self->_paginate( $self->next_page_uri );
}

=head2 prev_page

Get the L<Pithub::Result> of the previous page. Returns undef if there
is no previous page (you're on the first page).

Examples:

=over

=item *

List all followers in reverse order, from the last one on the last
page to the first one on the first page.

    $followers = Pithub->new->users->followers;
    $result = $followers->list( user => 'rjbs' )->last_page;    # this makes two requests!
    do {
        if ( $result->success ) {
            foreach my $row ( reverse @{ $result->content } ) {
                printf "%s\n", $row->{login};
            }
        }
    } while $result = $result->prev_page;

=back

=cut

sub prev_page {
    my ($self) = @_;
    return unless $self->prev_page_uri;
    return $self->_paginate( $self->prev_page_uri );
}

=head2 ratelimit

Returns the value of the C<< X-Ratelimit-Limit >> http header.

=cut

sub ratelimit {
    my ($self) = @_;
    return $self->response->http_response->header('X-RateLimit-Limit');
}

=head2 ratelimit_remaining

Returns the value of the C<< X-Ratelimit-Remaining >> http header.

=cut

sub ratelimit_remaining {
    my ($self) = @_;
    return $self->response->http_response->header('X-RateLimit-Remaining');
}

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
    my $link = $self->response->http_response->header('Link') or return;
    foreach my $item ( split /,/, $link ) {
        my @result = $item =~ /<([^>]+)>; rel="([^"]+)"/g;
        $self->{_get_link_header}{ $result[1] } = $result[0];
    }
    return $self->{_get_link_header}{$type};
}

sub _paginate {
    my ( $self, $uri_str ) = @_;
    my $uri     = URI->new($uri_str);
    my $options = {
        prepare_uri => sub { shift->query_form( $uri->query_form ) }
    };
    return $self->_request->( GET => $uri->path, undef, $options );
}

__PACKAGE__->meta->make_immutable;

1;
