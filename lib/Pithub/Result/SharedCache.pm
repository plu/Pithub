package Pithub::Result::SharedCache;

use Moo::Role;
use Cache::LRU;

my $Shared_Cache = Cache::LRU->new(
    size        => 200
);

=head1 DESCRIPTION

A role to share the least recently used cache with all Pithub objects.


=method shared_cache

Returns the Cache::LRU object shared by all Pithub objects.

=cut

sub shared_cache {
    return $Shared_Cache;
}

=method set_shared_cache

Sets the Cache::LRU object shared by all Pithub objects.

This should only be necessary for testing or to change the
size of the cache.

=cut

sub set_shared_cache {
    my($self, $cache) = @_;

    $Shared_Cache = $cache;

    return;
}

1;
