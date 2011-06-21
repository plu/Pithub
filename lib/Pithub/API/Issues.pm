package Pithub::API::Issues;

use Moose;
use namespace::autoclean;
extends 'Pithub::API::Base';

=head1 NAME

Pithub::API::Issues

=cut

has 'comments' => (
    is         => 'ro',
    isa        => 'Pithub::API::Issues::Comments',
    lazy_build => 1,
);

has 'events' => (
    is         => 'ro',
    isa        => 'Pithub::API::Issues::Events',
    lazy_build => 1,
);

has 'labels' => (
    is         => 'ro',
    isa        => 'Pithub::API::Issues::Labels',
    lazy_build => 1,
);

has 'milestones' => (
    is         => 'ro',
    isa        => 'Pithub::API::Issues::Milestones',
    lazy_build => 1,
);

sub _build_comments {
    return shift->_build('Pithub::API::Issues::Comments');
}

sub _build_events {
    return shift->_build('Pithub::API::Issues::Events');
}

sub _build_labels {
    return shift->_build('Pithub::API::Issues::Labels');
}

sub _build_milestones {
    return shift->_build('Pithub::API::Issues::Milestones');
}

__PACKAGE__->meta->make_immutable;

1;
