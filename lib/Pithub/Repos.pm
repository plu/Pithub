package Pithub::Repos;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Collaborators' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Commits' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Downloads' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Forks' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Watching' };

=head1 NAME

Pithub::API::Repos

=cut

__PACKAGE__->meta->make_immutable;

1;
