use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub;
use Scalar::Util qw(refaddr);
use Test::Most;

plan skip_all => 'Set PITHUB_TEST_LIVE to true to run these tests' unless $ENV{PITHUB_TEST_LIVE};

subtest "cached result" => sub {
    my $p = Pithub->new;
    my $result1 = $p->request(
        method  => 'GET',
        path    => '/'
    );

    my $result2 = $p->request(
        method  => 'GET',
        path    => '/'
    );

    is $result1->etag, $result2->etag;
    is refaddr $result1->response, refaddr $result2->response;
};


subtest "lru" => sub {
    my $p = Pithub->new;

    # Reduce the cache size to just two elements for easier testing
    $p->set_shared_cache( Cache::LRU->new( size => 2 ) );

    # Get two items to fill the cache
    my $repo_pithub = $p->repos->get( user => 'plu', repo => 'Pithub' );
    my $user_plu    = $p->users->get( user => 'plu' );

    # Get a third to bump $repo_pithub out
    my $branches = $p->repos->branches( user => 'plu', repo => 'Pithub', per_page => 1 );

    # Get $repo_pithub again, it should not be cached.
    my $repo_pithub2 = $p->repos->get( user => 'plu', repo => 'Pithub' );
    note "ETags @{[$repo_pithub->etag]} - @{[$repo_pithub2->etag]}";
    isnt refaddr $repo_pithub->response, refaddr $repo_pithub2->response;
};


done_testing;
