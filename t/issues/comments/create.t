use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Comments');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Comments';

throws_ok { $obj->create } qr{Missing key in parameters: issue_id}, 'No parameters';
throws_ok { $obj->create( issue_id => 1 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
throws_ok { $obj->create( issue_id => 1, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->create( issue_id => 1, data => { foo => 123 } ); } qr{Access token required for: POST /repos/foo/bar/issues/1/comments\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create(
        issue_id => 123,
        data     => { body => 'comment' }
    );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/issues/123/comments', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"body":"comment"}', 'HTTP body';
}

done_testing;
