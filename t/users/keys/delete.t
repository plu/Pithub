use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Keys');
}

my $obj = Pithub::Test->create('Pithub::Users::Keys');

isa_ok $obj, 'Pithub::Users::Keys';

throws_ok { $obj->delete } qr{Missing parameter: \$key_id}, 'Token required';
throws_ok { $obj->delete(123) } qr{Access token required for: DELETE /user/keys/123}, 'Token required';

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->delete(123);
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/user/keys/123', 'HTTP path';
}

done_testing;
