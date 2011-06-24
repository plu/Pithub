use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::PullRequests');
}

my $obj = Pithub::Test->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::PullRequests';

throws_ok { $obj->merge } qr{Missing key in parameters: pull_request_id}, 'No parameters';
throws_ok { $obj->merge( pull_request_id => 123 ); } qr{Access token required for: PUT /repos/foo/bar/pulls/123/merge}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->merge( pull_request_id => 123 );
    is $result->request->method, 'PUT', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/pulls/123/merge', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
