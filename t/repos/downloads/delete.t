use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Downloads');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Downloads', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Downloads';

throws_ok { $obj->delete } qr{Missing key in parameters: download_id}, 'No parameters';
throws_ok { $obj->delete( download_id => 123 ) } qr{Access token required for: DELETE /repos/foo/bar/downloads/123}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->delete( download_id => 123 );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/downloads/123', 'HTTP path';
}

done_testing;
