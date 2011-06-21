package Pithub::Users;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Emails' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Followers' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };

=head1 NAME

Pithub::API::Users

=cut

__PACKAGE__->meta->make_immutable;

1;
