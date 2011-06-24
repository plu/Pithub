use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Keys');
}

my $obj = Pithub::Test->create('Pithub::Users::Keys');

isa_ok $obj, 'Pithub::Users::Keys';

throws_ok { $obj->get } qr{Missing parameter: \$key_id}, 'Token required';
throws_ok { $obj->get(123) } qr{Access token required for: GET /user/keys/123}, 'Token required';

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->get(123);
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/keys/123', 'HTTP path';
}

done_testing;
