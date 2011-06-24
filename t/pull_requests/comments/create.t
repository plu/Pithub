use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::PullRequests::Comments');
}

my $obj = Pithub::Test->create( 'Pithub::PullRequests::Comments', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::PullRequests::Comments';

throws_ok { $obj->create } qr{Missing key in parameters: pull_request_id}, 'No parameters';
throws_ok { $obj->create( pull_request_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
throws_ok { $obj->create( pull_request_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
throws_ok {
    $obj->create( pull_request_id => 123, data => { foo => 'bar' } );
}
qr{Access token required for: POST /repos/foo/bar/pulls/123/comments}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create( pull_request_id => 123, data => { body => 'some comment' } );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/pulls/123/comments', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"body":"some comment"}', 'HTTP body';
}

done_testing;
