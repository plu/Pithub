use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Followers');
}

my $obj = Pithub::Test->create('Pithub::Users::Followers');

isa_ok $obj, 'Pithub::Users::Followers';

throws_ok { $obj->list_following } qr{Access token required for: GET /user/following}, 'Token required';

{
    my $result = $obj->list_following('plu');
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/plu/following', 'HTTP path';
}

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->list_following;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/following', 'HTTP path';
}

done_testing;
