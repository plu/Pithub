use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Keys');
}

my $obj = Pithub::Test->create('Pithub::Users::Keys');

isa_ok $obj, 'Pithub::Users::Keys';

throws_ok { $obj->update } qr{Missing parameter: \$key_id}, 'No parameters';
throws_ok { $obj->update(123) } qr{Missing parameter: \$data \(hashref\)}, 'No parameters';
throws_ok { $obj->update( 123 => { title => 1, key => 1 } ) } qr{Access token required for: PATCH /user/keys/123}, 'Token required';

ok $obj->token(123), 'Token set';

my $result = $obj->update( 123 => { title => 'plu@localhost', key => 'ssh-rsa AAA...' } );
is $result->request->method, 'PATCH', 'HTTP method';
is $result->request->uri->path, '/user/keys/123', 'HTTP path';

done_testing;
