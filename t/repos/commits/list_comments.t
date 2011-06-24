use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Commits');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Commits';

{
    my $result = $obj->list_comments;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/comments', 'HTTP path';
}

{
    my $result = $obj->list_comments( sha => 123 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/commits/123/comments', 'HTTP path';
}

done_testing;
