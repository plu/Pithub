use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users');
}

my $obj = Pithub::Test->create('Pithub::Users');

isa_ok $obj, 'Pithub::Users';

throws_ok { $obj->update } qr{Missing parameter: \$data \(hashref\)}, 'No parameters';
throws_ok { $obj->update( { foo => 'bar' } ) } qr{Access token required for: PATCH /user}, 'Token required';

ok $obj->token(123), 'Token set';

my $result = $obj->update( { email => 'foo@bar.com' } );
is $result->request->method, 'PATCH', 'HTTP method';
is $result->request->uri->path, '/user', 'HTTP path';

done_testing;
