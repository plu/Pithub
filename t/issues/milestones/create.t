use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Milestones');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Milestones';

throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->create( data => { name => 'foo' } ); } qr{Access token required for: POST /repos/foo/bar/milestones\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create(
        data => {
            description => 'String',
            due_on      => 'Time',
            state       => 'open or closed',
            title       => 'String'
        }
    );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/milestones', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"title":"String","due_on":"Time","description":"String","state":"open or closed"}', 'HTTP body';
}

done_testing;
