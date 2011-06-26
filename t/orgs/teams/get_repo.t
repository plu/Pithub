use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Teams');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

isa_ok $obj, 'Pithub::Orgs::Teams';

throws_ok { $obj->get_repo } qr{Missing key in parameters: team_id}, 'No parameters';
throws_ok { $obj->get_repo( team_id => 123 ) } qr{Missing key in parameters: repo}, 'No parameters';
throws_ok { $obj->get_repo( team_id => 123, repo => 'foo' ); } qr{Access token required for: GET /teams/123/repos/foo\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->get_repo( team_id => 123, repo => 'foo' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/teams/123/repos/foo', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
