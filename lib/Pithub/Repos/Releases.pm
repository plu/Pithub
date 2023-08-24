package Pithub::Repos::Releases;
our $VERSION = '0.01042';

# ABSTRACT: Github v3 Repo Releases API

use Moo;
use Carp                            qw( croak );
use Pithub::Repos::Releases::Assets ();
extends 'Pithub::Base';

=method assets

Provides access to L<Pithub::Repos::Releases::Assets>.

=cut

sub assets {
    return shift->_create_instance( Pithub::Repos::Releases::Assets::, @_ );
}

=method list

=over

=item *

List releases for a repository.

    GET /repos/:owner/:repo/releases

Examples:

    my $r = Pithub::Repos::Releases->new;
    my $result = $r->get(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/repos/%s/%s/releases', delete $args{user}, delete $args{repo}
        ),
        %args,
    );
}

=method get

=over

=item *

Get a single release.

    GET /repos/:owner/:repo/releases/:id

Examples:

    my $r = Pithub::Repos::Releases->new;
    my $result = $r->get(
        repo       => 'Pithub',
        user       => 'plu',
        release_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: release_id' unless $args{release_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/repos/%s/%s/releases/%d', delete $args{user},
            delete $args{repo},         delete $args{release_id}
        ),
        %args,
    );
}

=method create

=over

=item *

Create a release.

    POST /repos/:user/:repo/releases

Examples:

    my $r = Pithub::Repos::Releases->new;
    my $result = $r->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            tag_name         => 'v1.0.0',
            target_commitish => 'master',
            name             => 'v1.0.0',
            body             => 'Description of the release',
            draft            => JSON::MaybeXS::false(),           # or alternative below
            prerelease       => JSON::MaybeXS::false(),           # or alternative below
            generate_release_notes => JSON::MaybeXS::false(),     # or alternative below
        }
    );

Booleans:

Several of the attributes B<require> boolean values in the request that is sent
to GitHub.  Zero (0) and one (1) are integers and will not be encoded correctly
in the JSON encoded request.

There are numerous options for your call to Pithub::Repos::Releases->create.

=over

=item JSON::MaybeXS

Add the following to your code before the call to Pithub::Repos::Releases->create.

    require JSON::MaybeXS;

Then use the following values for the booleans:

    JSON::MaybeXS::true()
    JSON::MaybeXS::false()

=item Cpanel::JSON::XS

Add the following to your code before the call to Pithub::Repos::Releases->create.

    require Cpanel::JSON::XS;

Then use the following values for the booleans:

    Cpanel::JSON::XS::true
    Cpanel::JSON::XS::false

=item JSON::PP

Add the following to your code before the call to Pithub::Repos::Releases->create.

    require JSON::PP;

Then use the following values for the booleans:

    $JSON::PP::true
    $JSON::PP::false

=back

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)'
        unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf(
            '/repos/%s/%s/releases', delete $args{user}, delete $args{repo}
        ),
        %args,
    );
}

=method update

=over

=item *

Edit a release.

    PATCH /repos/:user/:repo/releases/:id

Examples:

    my $r = Pithub::Repos::Releases->new;
    my $result = $r->update(
        user       => 'plu',
        repo       => 'Pithub',
        release_id => 1,
        data       => {
            tag_name         => 'v1.0.0',
            target_commitish => 'master',
            name             => 'v1.0.0',
            body             => 'Description of the release',
            draft            => 0,
            prerelease       => 0,
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: release_id' unless $args{release_id};
    croak 'Missing key in parameters: data (hashref)'
        unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf(
            '/repos/%s/%s/releases/%d', delete $args{user},
            delete $args{repo},         delete $args{release_id}
        ),
        %args,
    );
}

=method delete

=over

=item *

Delete a release.

    DELETE /repos/:user/:repo/releases:id

Examples:

    my $r = Pithub::Repos::Releases->new;
    my $result = $r->delete(
        user       => 'plu',
        repo       => 'Pithub',
        release_id => 1,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: release_id' unless $args{release_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf(
            '/repos/%s/%s/releases/%d', delete $args{user},
            delete $args{repo},         delete $args{release_id}
        ),
        %args,
    );
}

1;
