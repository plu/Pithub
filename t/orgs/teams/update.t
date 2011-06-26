use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Teams');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

isa_ok $obj, 'Pithub::Orgs::Teams';

throws_ok { $obj->update } qr{Missing key in parameters: team_id}, 'No parameters';
throws_ok { $obj->update( team_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
throws_ok { $obj->update( team_id => 123, data => { foo => 1 } ); } qr{Access token required for: PATCH /teams/123\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update(
        team_id => 123,
        data    => {
            name       => 'new team name',
            permission => 'push',
        }
    );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/teams/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"permission":"push","name":"new team name"}', 'HTTP body';
}

done_testing;
