use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Collaborators');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Collaborators', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Collaborators';

throws_ok { $obj->add } qr{Missing key in parameters: collaborator}, 'No parameters';
throws_ok { $obj->add( collaborator => 'somebody' ) } qr{Access token required for: PUT /repos/foo/bar/collaborators/somebody}, 'Token required';

ok $obj->token(123), 'Token set';

my $result = $obj->add( collaborator => 'somebody' );
is $result->request->method, 'PUT', 'HTTP method';
is $result->request->uri->path, '/repos/foo/bar/collaborators/somebody', 'HTTP path';

done_testing;
