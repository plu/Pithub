package Pithub::GitData;

# ABSTRACT: Github v3 Git Data API

use Moo;
use Carp qw(croak);
use Pithub::GitData::Blobs;
use Pithub::GitData::Commits;
use Pithub::GitData::References;
use Pithub::GitData::Tags;
use Pithub::GitData::Trees;
extends 'Pithub::Base';

=method blobs

Provides access to L<Pithub::GitData::Blobs>.

=cut

sub blobs {
    return shift->_create_instance('Pithub::GitData::Blobs');
}

=method commits

Provides access to L<Pithub::GitData::Commits>.

=cut

sub commits {
    return shift->_create_instance('Pithub::GitData::Commits');
}

=method references

Provides access to L<Pithub::GitData::References>.

=cut

sub references {
    return shift->_create_instance('Pithub::GitData::References');
}

=method tags

Provides access to L<Pithub::GitData::Tags>.

=cut

sub tags {
    return shift->_create_instance('Pithub::GitData::Tags');
}

=method trees

Provides access to L<Pithub::GitData::Trees>.

=cut

sub trees {
    return shift->_create_instance('Pithub::GitData::Trees');
}

1;
