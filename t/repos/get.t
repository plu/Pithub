use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos');
}

my $obj = Pithub::Test->create( 'Pithub::Repos', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos';

{
    my $result = $obj->get;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
