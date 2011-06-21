package Pithub::Issues;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Events' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Labels' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Milestones' };

=head1 NAME

Pithub::API::Issues

=cut

__PACKAGE__->meta->make_immutable;

1;
