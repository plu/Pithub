use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Teams');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

isa_ok $obj, 'Pithub::Orgs::Teams';

throws_ok { $obj->remove_repo } qr{Missing key in parameters: team_id}, 'No parameters';
throws_ok { $obj->remove_repo( team_id => 123 ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { $obj->remove_repo( team_id => 123, repo => 'bar' ); } qr{Access token required for: DELETE /teams/123/repos/bar\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->remove_repo( team_id => 123, repo => 'bar' );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/teams/123/repos/bar', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
