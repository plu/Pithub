package Pithub::Repos::Contents;

# ABSTRACT: Github v3 Repo Contents API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method archive

=over

=item *

This method will return a C<< 302 >> to a URL to download a tarball
or zipball archive for a repository.

Note: For private repositories, these links are temporary and expire
quickly.

    GET /repos/:user/:repo/:archive_format/:ref

The C<< ref >> parameter is optional and will default to
C<< master >>.

Examples:

    my $c = Pithub::Repos::Contents->new(
        repo => 'Pithub',
        user => 'plu'
    );

    my $result = $c->archive( archive_format => 'tarball' );
    if ( $result->success ) {
        File::Slurp::write_file('Pithub-master.tgz', $result->raw_content);
    }

    $result = $c->archive( archive_format => 'tarball', ref => 'other_branch' );
    if ( $result->success ) {
        File::Slurp::write_file('Pithub-other_branch.tgz', $result->raw_content);
    }

=back

=cut

sub archive {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: archive_format' unless $args{archive_format};
    croak 'Invalid archive_format. Valid formats: tarball, zipball' unless grep $args{archive_format} eq $_, qw(tarball zipball);
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/%s/%s', delete $args{user}, delete $args{repo}, delete $args{archive_format}, delete $args{ref} || '' ),
        %args,
    );
}

=method get

=over

=item *

This method returns the contents of any file or directory in a
repository.

    GET /repos/:user/:repo/contents/:path

Optional Parameters:

=over

=item *

B<ref>: Optional string - The String name of the
Commit/Branch/Tag. Defaults to C<< master >>.

=back

Examples:

    my $c = Pithub::Repos::Contents->new(
        repo => 'Pithub',
        user => 'plu'
    );

    # List all files/directories in the repo root
    my $result = $c->get;
    if ( $result->success ) {
        say $_->{name} for @{ $result->content };
    }

    # Get the Pithub.pm file
    $result = $c->get( path => 'lib/Pithub.pm' );
    print Dumper $result->content if $result->success;

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $path = delete $args{path} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/repos/%s/%s/contents/%s', delete $args{user}, delete $args{repo}, $path ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/contents', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method readme

=over

=item *

This method returns the preferred README for a repository.

    GET /repos/:user/:repo/readme

Optional Parameters:

=over

=item *

B<ref>: Optional string - The String name of the
Commit/Branch/Tag. Defaults to C<< master >>.

=back

Examples:

    my $c = Pithub::Repos::Contents->new(
        repo => 'dotfiles',
        user => 'plu'
    );

    my $result = $c->readme;
    if ( $result->success ) {
        print Dumper $result->content;
    }

    # Get the readme of branch 'other_branch'
    $result = $c->readme( params => { ref => 'other_branch' } );
    print Dumper $result->content if $result->success;

=back

=cut

sub readme {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/readme', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

1;
