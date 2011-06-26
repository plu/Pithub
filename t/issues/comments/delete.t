use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Comments');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Comments';

throws_ok { $obj->delete } qr{Missing key in parameters: comment_id}, 'No parameters';
throws_ok { $obj->delete( comment_id => 123 ); } qr{DELETE /repos/foo/bar/issues/comments/123\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->delete( comment_id => 123, );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/issues/comments/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
