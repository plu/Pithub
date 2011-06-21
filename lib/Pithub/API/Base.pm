package Pithub::API::Base;

use Moose;
use Class::MOP;
use namespace::autoclean;

=head1 NAME

Pithub::API::Base

=cut

sub _build {
    my ( $self, $class ) = @_;
    Class::MOP::load_class($class);
    return $class->new;
}

__PACKAGE__->meta->make_immutable;

1;
