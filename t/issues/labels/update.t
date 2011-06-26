use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Labels');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Labels';

throws_ok { $obj->update } qr{Missing key in parameters: label_id}, 'No parameters';
throws_ok { $obj->update( label_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->update( label_id => 123, data => { name => 'foo' } ); } qr{Access token required for: PATCH /repos/foo/bar/labels/123\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update(
        label_id => 123,
        data     => {
            name  => 'label2',
            color => 'FF0000',
        }
    );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/labels/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"color":"FF0000","name":"label2"}', 'HTTP body';
}

done_testing;
