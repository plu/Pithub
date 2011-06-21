package Pithub::API::Repos;

use Moose;
use namespace::autoclean;
extends 'Pithub::API::Base';

=head1 NAME

Pithub::API::Repos

=cut

has 'collaborators' => (
    is         => 'ro',
    isa        => 'Pithub::API::Repos::Collaborators',
    lazy_build => 1,
);

has 'commits' => (
    is         => 'ro',
    isa        => 'Pithub::API::Repos::Commits',
    lazy_build => 1,
);

has 'downloads' => (
    is         => 'ro',
    isa        => 'Pithub::API::Repos::Downloads',
    lazy_build => 1,
);

has 'forks' => (
    is         => 'ro',
    isa        => 'Pithub::API::Repos::Forks',
    lazy_build => 1,
);

has 'keys' => (
    is         => 'ro',
    isa        => 'Pithub::API::Repos::Keys',
    lazy_build => 1,
);

has 'watching' => (
    is         => 'ro',
    isa        => 'Pithub::API::Repos::Watching',
    lazy_build => 1,
);

sub _build_collaborators {
    return shift->_build('Pithub::API::Repos::Collaborators');
}

sub _build_commits {
    return shift->_build('Pithub::API::Repos::Commits');
}

sub _build_downloads {
    return shift->_build('Pithub::API::Repos::Downloads');
}

sub _build_forks {
    return shift->_build('Pithub::API::Repos::Forks');
}

sub _build_keys {
    return shift->_build('Pithub::API::Repos::Keys');
}

sub _build_watching {
    return shift->_build('Pithub::API::Repos::Watching');
}

__PACKAGE__->meta->make_immutable;

1;
