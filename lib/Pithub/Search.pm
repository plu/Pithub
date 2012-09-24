package Pithub::Search;

# ABSTRACT: Github v3 Search API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method email

=over

=item *

This API call is added for compatibility reasons only. There's
no guarantee that full email searches will always be available.

    GET /legacy/user/email/:email

Examples:

    my $search = Pithub::Search->new;
    my $result = $search->email(
        email => 'plu@pqpq.de',
    );

=back

=cut

sub email {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: email' unless $args{email};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/legacy/user/email/%s', delete $args{email} ),
        %args,
    );
}

=method issues

=over

=item *

Find issues by state and keyword.

    GET /legacy/issues/search/:owner/:repository/:state/:keyword

Examples:

    my $search = Pithub::Search->new;
    my $result = $search->issues(
        user    => 'plu',
        repo    => 'Pithub',
        state   => 'open',
        keyword => 'some keyword',
    );

=back

=cut

sub issues {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    croak 'Missing key in parameters: state' unless $args{state};
    croak 'Missing key in parameters: keyword' unless $args{keyword};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/legacy/issues/search/%s/%s/%s/%s', delete $args{user}, delete $args{repo}, delete $args{state}, delete $args{keyword} ),
        %args,
    );
}

=method repos

=over

=item *

Find repositories by keyword. Note, this legacy method does not
follow the v3 pagination pattern. This method returns up to 100
results per page and pages can be fetched using the start_page
parameter.

    GET /legacy/repos/search/:keyword

Examples:

    my $search = Pithub::Search->new;
    my $result = $search->repos(
        keyword => 'github',
        params  => {
            language   => 'Perl',
            start_page => 0,
        }
    );

=back

=cut

sub repos {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: keyword' unless $args{keyword};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/legacy/repos/search/%s', delete $args{keyword} ),
        %args,
    );
}

=method users

=over

=item *

Find users by keyword.

    GET /legacy/user/search/:keyword

Examples:

    my $search = Pithub::Search->new;
    my $result = $search->users(
        keyword => 'plu',
    );

=back

=cut

sub users {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: keyword' unless $args{keyword};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/legacy/user/search/%s', delete $args{keyword} ),
        %args,
    );
}

1;
