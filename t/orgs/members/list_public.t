use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Members');
}

my $obj = Pithub::Test->create( 'Pithub::Orgs::Members', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Orgs::Members';

throws_ok { $obj->list_public } qr{Missing key in parameters: org}, 'No parameters';

{
    my $result = $obj->list_public( org => 'foo' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/orgs/foo/public_members', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
