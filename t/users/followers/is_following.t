use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users::Followers');
}

my $obj = Pithub::Test->create('Pithub::Users::Followers');

isa_ok $obj, 'Pithub::Users::Followers';

throws_ok { $obj->is_following } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { $obj->is_following( user => 'rafl' ) } qr{Access token required for: GET /user/following/rafl}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->is_following( user => 'rafl' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/following/rafl', 'HTTP path';

    ok $result->response->parse_response( Pithub::Test->get_response('users.followers.is_following.success') ), 'Load response' if $obj->skip_request;

    is $result->code,        204, 'HTTP status';
    is $result->success,     1,   'Successful';
    is $result->raw_content, '',  'HTTP body is empty';
    eq_or_diff $result->content, {}, 'Empty HTTP body generates empty hashref';
}

done_testing;
