package Pithub::Result;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Result

=cut

has 'auto_pagination' => (
    default => 0,
    is      => 'rw',
    isa     => 'Bool',
);

__PACKAGE__->meta->make_immutable;

1;
