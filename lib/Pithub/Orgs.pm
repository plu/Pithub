package Pithub::Orgs;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Members' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Teams' };

=head1 NAME

Pithub::API::Orgs

=cut

__PACKAGE__->meta->make_immutable;

1;
