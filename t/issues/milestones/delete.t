use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Milestones');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Milestones';

throws_ok { $obj->delete } qr{Missing key in parameters: milestone_id}, 'No parameters';
throws_ok { $obj->delete( milestone_id => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/milestones/123\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->delete( milestone_id => 123 );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/milestones/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
