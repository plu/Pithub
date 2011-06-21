package Pithub::API::PullRequests;

use Moose;
use namespace::autoclean;
extends 'Pithub::API::Base';

=head1 NAME

Pithub::API::PullRequests

=cut

has 'comments' => (
    is         => 'ro',
    isa        => 'Pithub::API::PullRequests::Comments',
    lazy_build => 1,
);

sub _build_comments {
    return shift->_build('Pithub::API::PullRequests::Comments');
}

__PACKAGE__->meta->make_immutable;

1;
