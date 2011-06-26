use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Milestones');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Milestones';

{
    my $result = $obj->list;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/milestones', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
