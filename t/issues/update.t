use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues');
}

my $obj = Pithub::Test->create( 'Pithub::Issues', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues';

throws_ok { $obj->update } qr{Missing key in parameters: issue_id}, 'No parameters';
throws_ok { $obj->update( issue_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->update( issue_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->update( issue_id => 123, data => { foo => 123 } ); } qr{Access token required for: PATCH /repos/foo/bar/issues/123}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update(
        issue_id => 123,
        data     => {
            assignee  => 'octocat',
            body      => "I'm having a problem with this.",
            labels    => [ 'Label1', 'Label2' ],
            milestone => 1,
            state     => 'open',
            title     => 'Found a bug'
        }
    );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/issues/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content,
      '{"body":"I\'m having a problem with this.","assignee":"octocat","milestone":1,"title":"Found a bug","labels":["Label1","Label2"],"state":"open"}',
      'HTTP body';
}

done_testing;
