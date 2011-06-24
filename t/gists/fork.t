use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Gists');
}

my $obj = Pithub::Test->create('Pithub::Gists');

isa_ok $obj, 'Pithub::Gists';

throws_ok { $obj->fork } qr{Missing parameter: \$gist_id}, 'No parameter';

{
    my $result = $obj->fork(123);
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/gists/123/fork', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
