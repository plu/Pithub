package Pithub::Search;

# ABSTRACT: Github v3 Search API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

sub emails {
    my ( $self, %args ) = @_;
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

sub repos {
    my ( $self, %args ) = @_;
}

sub users {
    my ( $self, %args ) = @_;
}

1;
