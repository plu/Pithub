package Pithub::Result::SharedCache;

use Moo::Role;

our $VERSION = '0.01041';
# ABSTRACT: A role to share the LRU cache with all Pithub objects

use CHI ();

my $store = {};

my $Shared_Cache = CHI->new(
    datastore => $store,
    driver    => 'RawMemory',
    max_size  => 200,
    size      => 200,
);

=head1 DESCRIPTION

A role to share the least recently used cache with all Pithub objects.

=method shared_cache

Returns the L<CHI> object shared by all Pithub objects.

=cut

sub shared_cache {
    return $Shared_Cache;
}

=method set_shared_cache

Sets the CHI object shared by all Pithub objects.

This should only be necessary for testing or to change the
size of the cache.

=cut

sub set_shared_cache {
    my($self, $cache) = @_;

    $Shared_Cache = $cache;

    return;
}

1;
