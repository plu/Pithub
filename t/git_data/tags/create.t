use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::GitData::Tags');
}

my $obj = Pithub::Test->create( 'Pithub::GitData::Tags', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::GitData::Tags';

throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->create( data => { bla => 'fasel' } ); } qr{Access token required for: POST /repos/foo/bar/git/tags}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create(
        data => {
            message => 'Tagged v0.1',
            object  => '827efc6d56897b048c772eb4087f854f46256132',
            tag     => 'v0.1',
            type    => 'commit',
        }
    );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/git/tags', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"object":"827efc6d56897b048c772eb4087f854f46256132","type":"commit","tag":"v0.1","message":"Tagged v0.1"}', 'HTTP body';
}

done_testing;
