package Pithub::SearchV3;
our $VERSION = '0.01039';
# ABSTRACT: Github v3 Search API

use Moo;
use Carp qw( croak );
extends 'Pithub::Base';

=method issues

=over

=item *

Find issues by state and keyword.

    GET /search/issues

Examples:

    my $search = Pithub::Search->new;
    my $result = $search->issues(
        q => 'some keyword',
    );

=back

=cut

sub issues {
    my $self = shift;
    return $self->_search('issues', @_);
}

=method repos

=over

=item *

Find repositories by keyword.

    GET /search/repositories

Examples:

    my $search = Pithub::SearchV3->new;
    my $result = $search->repos(
        q => 'github language:Perl',
    );

=back

=cut

sub repos {
    my $self = shift;
    return $self->_search('repositories', @_);
}

=method users

=over

=item *

Find users by keyword.

    GET /search/users

Examples:

    my $search = Pithub::SearchV3->new;
    my $result = $search->users(
        q => 'plu',
    );

=back

=cut

sub users {
    my $self = shift;
    return $self->_search('users', @_);
}

=method code

=over

=item *

Search code by keyword.

    GET /search/code

Examples:

    my $search = Pithub::SearchV3->new;
    my $result = $search->code(
        q => 'addClass repo:jquery/jquery',
    );

=back

=cut

sub code {
    my $self = shift;
    return $self->_search('code', @_);
}

sub _search {
    my ( $self, $thing_to_search, %args ) = @_;
    croak 'Missing key in parameters: q' unless exists $args{q};
    return $self->request(
        method => 'GET',
        path   => '/search/' . $thing_to_search,
        query => {
            q => delete $args{q},
            (exists $args{sort}  ? (sort  => delete $args{sort})  : ()),
            (exists $args{order} ? (order => delete $args{order}) : ()),
        },
        %args,
    );
}

1;
