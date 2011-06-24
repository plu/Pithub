use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Gists::Comments');
}

my $obj = Pithub::Test->create('Pithub::Gists::Comments');

isa_ok $obj, 'Pithub::Gists::Comments';

throws_ok { $obj->list } qr{Missing key in parameters: gist_id}, 'No parameters';

{
    my $result = $obj->list( gist_id => 123 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/gists/123/comments', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
