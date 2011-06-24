use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Gists');
}

my $obj = Pithub::Test->create('Pithub::Gists');

isa_ok $obj, 'Pithub::Gists';

throws_ok { $obj->update } qr{Missing parameter: \$gist_id}, 'No parameter';
throws_ok { $obj->update(123) } qr{Missing parameter: \$data \(hashref\)}, 'No data parameter';
throws_ok { $obj->update( 123, { foo => 'bar' } ) } qr{Access token required for: PATCH /gists/123}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update(
        123 => {
            description => 'the description for this gist',
            public      => 1,
            files       => { 'file1.txt' => { content => 'String file content' } }
        }
    );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/gists/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content,
      '{"files":{"file1.txt":{"content":"String file content"}},"public":1,"description":"the description for this gist"}',
      'HTTP body';
}

done_testing;
