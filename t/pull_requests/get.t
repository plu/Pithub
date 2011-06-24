use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::PullRequests');
}

my $obj = Pithub::Test->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

throws_ok { $obj->get } qr{Missing key in parameters: pull_request_id}, 'No parameters';

isa_ok $obj, 'Pithub::PullRequests';

{
    my $result = $obj->get( pull_request_id => 1 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/pulls/1', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
