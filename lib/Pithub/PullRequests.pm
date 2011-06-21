package Pithub::PullRequests;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };

=head1 NAME

Pithub::API::PullRequests

=cut

__PACKAGE__->meta->make_immutable;

1;
