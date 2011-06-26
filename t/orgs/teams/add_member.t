use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Teams');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

isa_ok $obj, 'Pithub::Orgs::Teams';

throws_ok { $obj->add_member } qr{Missing key in parameters: team_id}, 'No parameters';
throws_ok { $obj->add_member( team_id => 123 ) } qr{Missing key in parameters: user}, 'No user parameter';
throws_ok { $obj->add_member( team_id => 123, user => 'bar' ); } qr{Access token required for: PUT /teams/123/members/bar\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->add_member( team_id => 123, user => 'bar' );
    is $result->request->method, 'PUT', 'HTTP method';
    is $result->request->uri->path, '/teams/123/members/bar', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
