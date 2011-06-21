package Pithub::API::Gists;

use Moose;
use namespace::autoclean;
extends 'Pithub::API::Base';

=head1 NAME

Pithub::API::Gists

=cut

has 'comments' => (
    is         => 'ro',
    isa        => 'Pithub::API::Gists::Comments',
    lazy_build => 1,
);

sub _build_comments {
    return shift->_build('Pithub::API::Gists::Comments');
}

__PACKAGE__->meta->make_immutable;

1;
