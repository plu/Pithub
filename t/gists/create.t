use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Gists');
}

my $obj = Pithub::Test->create('Pithub::Gists');

isa_ok $obj, 'Pithub::Gists';

throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';

{
    my $result = $obj->create(
        data => {
            description => 'the description for this gist',
            public      => 1,
            files       => { 'file1.txt' => { content => 'String file content' } }
        }
    );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/gists', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content,
      '{"files":{"file1.txt":{"content":"String file content"}},"public":1,"description":"the description for this gist"}',
      'HTTP body';
}

done_testing;
