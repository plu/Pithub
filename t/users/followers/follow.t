use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Followers');
}

my $obj = Pithub::Test->create('Pithub::Users::Followers');

isa_ok $obj, 'Pithub::Users::Followers';

throws_ok { $obj->follow } qr{Missing parameter: \$user}, 'No parameters';
throws_ok { $obj->follow('plu') } qr{Access token required for: PUT /user/following/plu}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->follow('plu');
    is $result->request->method, 'PUT', 'HTTP method';
    is $result->request->uri->path, '/user/following/plu', 'HTTP path';
}

done_testing;
