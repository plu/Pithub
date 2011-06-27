use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Followers');
}

my $obj = Pithub::Test->create('Pithub::Users::Followers');

isa_ok $obj, 'Pithub::Users::Followers';

throws_ok { $obj->unfollow } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { $obj->unfollow( user => 'plu' ) } qr{Access token required for: DELETE /user/following/plu}, 'Token required';

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->unfollow( user => 'plu' );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/user/following/plu', 'HTTP path';
}

done_testing;
