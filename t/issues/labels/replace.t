use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Labels');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Labels';

throws_ok { $obj->add } qr{Missing key in parameters: issue_id}, 'No parameters';
throws_ok { $obj->replace( issue_id => 1 ) } qr{Missing key in parameters: data \(arrayref\)}, 'No data parameter';
throws_ok { $obj->replace( issue_id => 1, data => 5 ) } qr{Missing key in parameters: data \(arrayref\)}, 'Wrong data parameter';
throws_ok { $obj->replace( issue_id => 123, data => [qw(label1 label2)] ); }
qr{Access token required for: PUT /repos/foo/bar/issues/123/labels\s+},
  'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->replace(
        issue_id => 123,
        data     => [qw(label1 label2)],
    );
    is $result->request->method, 'PUT', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/issues/123/labels', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '["label1","label2"]', 'HTTP body';
}

done_testing;
