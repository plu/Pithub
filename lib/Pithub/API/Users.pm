package Pithub::API::Users;

use Moose;
use namespace::autoclean;
extends 'Pithub::API::Base';

=head1 NAME

Pithub::API::Users

=cut

has 'emails' => (
    is         => 'ro',
    isa        => 'Pithub::API::Users::Emails',
    lazy_build => 1,
);

has 'followers' => (
    is         => 'ro',
    isa        => 'Pithub::API::Users::Followers',
    lazy_build => 1,
);

has 'keys' => (
    is         => 'ro',
    isa        => 'Pithub::API::Users::Keys',
    lazy_build => 1,
);

sub _build_emails {
    return shift->_build('Pithub::API::Users::Emails');
}

sub _build_followers {
    return shift->_build('Pithub::API::Users::Followers');
}

sub _build_keys {
    return shift->_build('Pithub::API::Users::Keys');
}

__PACKAGE__->meta->make_immutable;

1;
