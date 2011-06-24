use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos');
}

my $obj = Pithub::Test->create('Pithub::Repos');

isa_ok $obj, 'Pithub::Repos';

throws_ok { $obj->list } qr{Access token required for: GET /user/repos}, 'Token required';

{
    my $result = $obj->list( user => 'plu' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/users/plu/repos', 'HTTP path';

    ok $result->response->parse_response( Pithub::Test->get_response('repos.list.user') ), 'Load response' if $obj->skip_request;

    is $result->code,    200, 'HTTP status';
    is $result->success, 1,   'Successful';

    is $result->content->[0]{clone_url}, 'https://github.com/plu/poe-component-irc-plugin-blowfish.git', 'Attribute exists: clone_url';
    is $result->content->[1]{clone_url}, 'https://github.com/plu/efa-wdgt-common.git', 'Attribute exists: clone_url';
    is $result->content->[0]{owner}{login}, 'plu', 'Attribute exists: owner.login';
    is $result->content->[1]{owner}{login}, 'plu', 'Attribute exists: owner.login';
}

{
    my $result = $obj->list( org => 'CPAN-API' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/orgs/CPAN-API/repos', 'HTTP path';

    ok $result->response->parse_response( Pithub::Test->get_response('repos.list.org') ), 'Load response' if $obj->skip_request;

    is $result->code,    200, 'HTTP status is 200';
    is $result->success, 1,   'Successful';

    is $result->content->[0]{git_url}, 'git://github.com/CPAN-API/cpan-api.git',            'Attribute exists: git_url';
    is $result->content->[1]{git_url}, 'git://github.com/CPAN-API/search-metacpan-org.git', 'Attribute exists: git_url';
    is $result->content->[0]{owner}{id}, 460239, 'Attribute exists: owner.id';
    is $result->content->[1]{owner}{id}, 460239, 'Attribute exists: owner.id';
}

{
    $obj->token(123);
    my $result = $obj->list;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/repos', 'HTTP path';
}

done_testing;
