package Pithub::Repos::Actions;

# ABSTRACT: Github v3 Repo Actions API

use Moo;

our $VERSION = '0.01040';

use Pithub::Repos::Actions::Workflows ();

extends 'Pithub::Base';

=head1 DESCRIPTION

This class is incomplete. Please send patches for any additional functionality
you may require.

=method workflows

Provides access to L<Pithub::Repos::Actions::Worfklows>.

=cut

sub workflows {
    return shift->_create_instance( Pithub::Repos::Actions::Workflows::, @_ );
}

1;
