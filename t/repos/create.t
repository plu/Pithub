use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos');
}

my $obj = Pithub::Test->create('Pithub::Repos');

isa_ok $obj, 'Pithub::Repos';

throws_ok { $obj->create } qr{Invalid parameters}, 'No parameters';
throws_ok { $obj->create( { foo => 1 } ) } qr{Access token required for: POST /user/repos}, 'Token required';
throws_ok { $obj->create( foobarorg => { foo => 1 } ) } qr{Access token required for: POST /orgs/foobarorg/repos}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create( { foo => 1 } );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/user/repos', 'HTTP path';
}

{
    my $result = $obj->create( foobarorg => { foo => 1 } );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/orgs/foobarorg/repos', 'HTTP path';
}

done_testing;
