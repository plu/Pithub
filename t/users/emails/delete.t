use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Emails');
}

my $obj = Pithub::Test->create('Pithub::Users::Emails');

isa_ok $obj, 'Pithub::Users::Emails';

throws_ok { $obj->delete } qr{Missing parameter: \$email \(string or arrayref\)}, 'No parameters';
throws_ok { $obj->delete('xxx') } qr{Access token required for: DELETE /user/emails}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->delete('foo@bar.com');
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/user/emails', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '["foo@bar.com"]', 'HTTP body';
}

{
    my $result = $obj->delete( [ 'foo@bar.com', 'bar@foo.com' ] );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/user/emails', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '["foo@bar.com","bar@foo.com"]', 'HTTP body';
}

done_testing;
