use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Forks');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Forks', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Forks';

throws_ok { $obj->create } qr{POST /repos/foo/bar/forks}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create;
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/forks', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

{
    my $result = $obj->create( org => 'foobarorg' );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/forks', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"org":"foobarorg"}', 'HTTP body';
}

done_testing;
