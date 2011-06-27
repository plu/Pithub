use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Keys');
}

my $obj = Pithub::Test->create('Pithub::Users::Keys');

isa_ok $obj, 'Pithub::Users::Keys';

throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->create( data => { foo => 'bar' } ) } qr{Access token required for: POST /user/keys}, 'Token required';

ok $obj->token(123), 'Token set';

my $result = $obj->create( data => { title => 'plu@localhost', key => 'ssh-rsa AAA...' } );
is $result->request->method, 'POST', 'HTTP method';
is $result->request->uri->path, '/user/keys', 'HTTP path';

done_testing;
