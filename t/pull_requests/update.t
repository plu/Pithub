use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::PullRequests');
}

my $obj = Pithub::Test->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::PullRequests';

throws_ok { $obj->update } qr{Missing key in parameters: pull_request_id}, 'No parameter';
throws_ok { $obj->update( pull_request_id => 1 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
throws_ok { $obj->update( pull_request_id => 5, data => { foo => 'bar' } ); } qr{Access token required for: PATCH /repos/foo/bar/pulls/5}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update(
        pull_request_id => 123,
        data            => {
            base  => 'master',
            body  => 'Please pull this in!',
            head  => 'octocat:new-feature',
            title => 'Amazing new feature',
        }
    );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/pulls/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"body":"Please pull this in!","base":"master","head":"octocat:new-feature","title":"Amazing new feature"}', 'HTTP body';
}

done_testing;
