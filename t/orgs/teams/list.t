use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Teams');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

isa_ok $obj, 'Pithub::Orgs::Teams';

throws_ok { $obj->list } qr{Missing key in parameters: org}, 'No parameters';
throws_ok { $obj->list( org => 'foorg' ); } qr{Access token required for: GET /orgs/foorg/teams\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->list( org => 'foorg' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/orgs/foorg/teams', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
