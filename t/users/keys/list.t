use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Keys');
}

my $obj = Pithub::Test->create('Pithub::Users::Keys');

isa_ok $obj, 'Pithub::Users::Keys';

throws_ok { $obj->list } qr{Access token required for: GET /user/keys}, 'Token required';

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->list;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/keys', 'HTTP path';
}

done_testing;
