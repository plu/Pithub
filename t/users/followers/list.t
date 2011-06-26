use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Followers');
}

my $obj = Pithub::Test->create('Pithub::Users::Followers');

isa_ok $obj, 'Pithub::Users::Followers';

throws_ok { $obj->list } qr{Access token required for: GET /user/followers}, 'Token required';

{
    my $result = $obj->list('plu');
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/users/plu/followers', 'HTTP path';
}

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->list;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/followers', 'HTTP path';
}

done_testing;
