use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::GitData::Tags');
}

my $obj = Pithub::Test->create( 'Pithub::GitData::Tags', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::GitData::Tags';

throws_ok { $obj->get } qr{Missing key in parameters: sha}, 'No parameters';

{
    my $result = $obj->get( sha => 123 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/git/tags/123', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
