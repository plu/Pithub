use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Teams');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

isa_ok $obj, 'Pithub::Orgs::Teams';

throws_ok { $obj->is_member } qr{Missing key in parameters: team_id}, 'No parameters';
throws_ok { $obj->is_member( team_id => 123 ) } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { $obj->is_member( team_id => 123, user => 'foo' ); } qr{Access token required for: GET /teams/123/members/foo\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->is_member( team_id => 123, user => 'foo' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/teams/123/members/foo', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
