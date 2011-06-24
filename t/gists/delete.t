use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Gists');
}

my $obj = Pithub::Test->create('Pithub::Gists');

isa_ok $obj, 'Pithub::Gists';

throws_ok { $obj->delete } qr{Missing parameter: \$gist_id}, 'No parameter';
throws_ok { $obj->delete(123) } qr{Access token required for: DELETE /gists/123}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->delete(123);
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/gists/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
