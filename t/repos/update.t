use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos');
}

my $obj = Pithub::Test->create('Pithub::Repos');

isa_ok $obj, 'Pithub::Repos';

throws_ok { $obj->update } qr{Missing parameter: \$name}, 'No parameters';
throws_ok { $obj->update('bar') } qr{Missing parameter: \$data \(hashref\)}, 'Missing data';
throws_ok { $obj->update( bar => { foo => 1 } ) } qr{Access token required for: PATCH /user/repos/bar}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update( foobarorg => { foo => 1 } );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/user/repos/foobarorg', 'HTTP path';
}

done_testing;
