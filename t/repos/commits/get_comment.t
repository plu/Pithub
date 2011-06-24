use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Commits');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Commits';

throws_ok { $obj->get_comment } qr{Missing key in parameters: comment_id}, 'No parameters';

{
    my $result = $obj->get_comment( comment_id => 123 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/comments/123', 'HTTP path';
}

done_testing;
