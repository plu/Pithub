use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Members');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Members');

isa_ok $obj, 'Pithub::Orgs::Members';

throws_ok { $obj->is_public } qr{Missing key in parameters: org}, 'No parameters';
throws_ok { $obj->is_public( org => 'foo-org' ) } qr{Missing key in parameters: user}, 'No user parameter';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->is_public( org => 'foo', user => 'bar' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/orgs/foo/public_members/bar', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
