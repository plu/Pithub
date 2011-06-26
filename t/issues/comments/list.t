use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Comments');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Comments';

throws_ok { $obj->list } qr{Missing key in parameters: issue_id}, 'No parameters';

{
    my $result = $obj->list( issue_id => 123, );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/issues/123/comments', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
