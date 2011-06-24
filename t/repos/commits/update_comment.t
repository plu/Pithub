use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Commits');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Commits';

throws_ok { $obj->update_comment } qr{Missing key in parameters: comment_id}, 'No parameters';
throws_ok { $obj->update_comment( comment_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
throws_ok { $obj->update_comment( comment_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
throws_ok { $obj->update_comment( comment_id => 123, data => { foo => 'bar' } ) } qr{Access token required for: PATCH /repos/foo/bar/comments/123},
  'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update_comment( comment_id => 123, data => { body => 'some comment' } );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/comments/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"body":"some comment"}', 'HTTP body';
}

done_testing;
