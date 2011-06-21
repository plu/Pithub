package Pithub::GitData;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Blobs' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Commits' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::References' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Tags' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Trees' };

=head1 NAME

Pithub::GitData

=cut

__PACKAGE__->meta->make_immutable;

1;
