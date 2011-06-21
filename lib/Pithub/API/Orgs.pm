package Pithub::API::Orgs;

use Moose;
use namespace::autoclean;
extends 'Pithub::API::Base';

=head1 NAME

Pithub::API::Orgs

=cut

has 'members' => (
    is         => 'ro',
    isa        => 'Pithub::API::Orgs::Members',
    lazy_build => 1,
);

has 'teams' => (
    is         => 'ro',
    isa        => 'Pithub::API::Orgs::Teams',
    lazy_build => 1,
);

sub _build_members {
    return shift->_build('Pithub::API::Orgs::Members');
}

sub _build_teams {
    return shift->_build('Pithub::API::Orgs::Teams');
}

__PACKAGE__->meta->make_immutable;

1;
