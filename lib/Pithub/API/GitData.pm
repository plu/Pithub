package Pithub::API::GitData;

use Moose;
use namespace::autoclean;
extends 'Pithub::API::Base';

=head1 NAME

Pithub::API::GitData

=cut

has 'blobs' => (
    is         => 'ro',
    isa        => 'Pithub::API::GitData::Blobs',
    lazy_build => 1,
);

has 'commits' => (
    is         => 'ro',
    isa        => 'Pithub::API::GitData::Commits',
    lazy_build => 1,
);

has 'references' => (
    is         => 'ro',
    isa        => 'Pithub::API::GitData::References',
    lazy_build => 1,
);

has 'tags' => (
    is         => 'ro',
    isa        => 'Pithub::API::GitData::Tags',
    lazy_build => 1,
);

has 'trees' => (
    is         => 'ro',
    isa        => 'Pithub::API::GitData::Trees',
    lazy_build => 1,
);

sub _build_blobs {
    return shift->_build('Pithub::API::GitData::Blobs');
}

sub _build_commits {
    return shift->_build('Pithub::API::GitData::Commits');
}

sub _build_references {
    return shift->_build('Pithub::API::GitData::References');
}

sub _build_tags {
    return shift->_build('Pithub::API::GitData::Tags');
}

sub _build_trees {
    return shift->_build('Pithub::API::GitData::Trees');
}

__PACKAGE__->meta->make_immutable;

1;
