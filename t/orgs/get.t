use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs');
}

my $obj = Pithub::Test->create( 'Pithub::Orgs', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Orgs';

throws_ok { $obj->get } qr{Missing key in parameters: org}, 'No parameters';

{
    my $result = $obj->get( org => 'some-org' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/orgs/some-org', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
