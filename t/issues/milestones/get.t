use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Milestones');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Milestones';

throws_ok { $obj->get } qr{Missing key in parameters: milestone_id}, 'No parameters';

{
    my $result = $obj->get( milestone_id => 123 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/milestones/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
