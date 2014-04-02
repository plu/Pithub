package Pithub::Repos::Releases::Assets;

# ABSTRACT: Github v3 Repo Releases Assets API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

=over

=item *

Upload a release asset.

    POST https://uploads.github.com/repos/:owner/:repo/releases/:id/assets?name=foo.zip

Examples:

    my $a = Pithub::Repos::Releases::Assets->new;
    my $result = $a->create(
        repo         => 'graylog2-server',
        user         => 'Graylog2',
        release_id   => 81148,
        name         => 'Some Asset',
        data         => 'the asset data',
        content_type => 'text/plain',
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: name' unless $args{name};
    croak 'Missing key in parameters: release_id' unless $args{release_id};
    croak 'Missing key in parameters: data' unless $args{data};
    croak 'Missing key in parameters: content_type' unless $args{content_type};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method  => 'POST',
        path    => sprintf( '/repos/%s/%s/releases/%s/assets', delete $args{user}, delete $args{repo}, delete $args{release_id} ),
        host    => 'uploads.github.com',
        query   => { name => delete $args{name} },
        headers => {
            'Content-Type' => delete $args{content_type},
        },
        %args,
    );
}

=method delete

=over

=item *

Delete a release asset.

    DELETE /repos/:owner/:repo/releases/assets/:id

Examples:

    my $a = Pithub::Repos::Releases::Assets->new;
    my $result = $a->delete(
        repo     => 'graylog2-server',
        user     => 'Graylog2',
        asset_id => 81148,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: asset_id' unless $args{asset_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/releases/assets/%s', delete $args{user}, delete $args{repo}, delete $args{asset_id} ),
        %args,
    );
}

=method get

=over

=item *

Get a single release asset.

    GET /repos/:owner/:repo/releases/assets/:id

Examples:

    my $a = Pithub::Repos::Releases::Assets->new;
    my $result = $a->get(
        repo     => 'graylog2-server',
        user     => 'Graylog2',
        asset_id => 81148,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: asset_id' unless $args{asset_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/releases/assets/%s', delete $args{user}, delete $args{repo}, delete $args{asset_id} ),
        %args,
    );
}

=method list

=over

=item *

List assets for a release.

    GET /repos/:owner/:repo/releases/:id/assets

Examples:

    my $a = Pithub::Repos::Releases::Assets->new;
    my $result = $a->list(
        repo       => 'graylog2-server',
        user       => 'Graylog2',
        release_id => 198110,
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: release_id' unless $args{release_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/releases/%s/assets', delete $args{user}, delete $args{repo}, delete $args{release_id} ),
        %args,
    );
}

=method update

=over

=item *

Edit a release asset.

    PATCH /repos/:owner/:repo/releases/assets/:id

Examples:

    my $a = Pithub::Repos::Releases::Assets->new;
    my $result = $a->update(
        repo     => 'graylog2-server',
        user     => 'Graylog2',
        asset_id => 81148,
        data     => {
            name  => 'Some Name',
            label => 'Some Label',
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: asset_id' unless $args{asset_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method  => 'PATCH',
        path    => sprintf( '/repos/%s/%s/releases/assets/%s', delete $args{user}, delete $args{repo}, delete $args{asset_id} ),
        %args,
    );
}

1;
