package Pithub::GitData::Blobs;

# ABSTRACT: Github v3 Git Data Blobs API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=head1 DESCRIPTION

Since blobs can be any arbitrary binary data, the input and responses
for the blob api takes an encoding parameter that can be either
C<< utf-8 >> or C<< base64 >>. If your data cannot be losslessly sent
as a UTF-8 string, you can base64 encode it.

=method create

=over

=item *

Create a Blob

    POST /repos/:user/:repo/git/blobs

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<data>: mandatory hashref, having following keys:

=over

=item *

B<content>: mandatory string

=item *

B<encoding>: mandatory string, C<< utf-8 >> or C<< base64 >>

=back

=back

Examples:

    my $b = Pithub::GitData::Blobs->new;
    my $result = $b->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            content  => 'Content of the blob',
            encoding => 'utf-8',
        }
    );

Response: B<Status: 201 Created>

    {
        "sha": "3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15"
    }

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/git/blobs', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a Blob

    GET /repos/:user/:repo/git/blobs/:sha

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<sha>: mandatory string

=back

Examples:

    my $b = Pithub::GitData::Blobs->new;
    my $result = $b->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'b7cdea6830e128bc16c2b75efd99842d971666e2',
    );

Response: B<Status: 200 OK>

    {
        "content": "Content of the blob",
        "encoding": "utf-8"
    }

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/blobs/%s', delete $args{user}, delete $args{repo}, delete $args{sha} ),
        %args,
    );
}

1;
