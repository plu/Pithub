use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Events');
}

{
    my $obj = Pithub::Test->create( 'Pithub::Events', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Events';

    throws_ok { $obj->org_for_user( user => 'foo', org => 'bar' ) } qr{Access token required for: GET /users/foo/events/orgs/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    throws_ok { $obj->org } qr{Missing key in parameters: org},          'No parameters';
    throws_ok { $obj->org_for_user } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->org_for_user( org => 'foo' ) } qr{Missing key in parameters: user}, 'No parameters';
    throws_ok { $obj->user_performed } qr{Missing key in parameters: user}, 'No parameters';
    throws_ok { $obj->user_received } qr{Missing key in parameters: user},  'No parameters';

    my @tests = (
        {
            method => 'issue',
            path   => '/repos/foo/bar/issues/events',
        },
        {
            method => 'network',
            path   => '/networks/foo/bar/events',
        },
        {
            method => 'public',
            path   => '/events',
        },
        {
            method => 'repos',
            path   => '/repos/foo/bar/events',
        },
        {
            method => 'org',
            params => [ org => 'some-org' ],
            path   => '/orgs/some-org/events',
        },
        {
            method => 'org_for_user',
            params => [ org => 'some-org', user => 'some-user' ],
            path   => '/users/some-user/events/orgs/some-org',
        },
        {
            method => 'user_performed',
            params => [ user => 'some-user' ],
            path   => '/users/some-user/events',
        },
        {
            method => 'user_received',
            params => [ user => 'some-user' ],
            path   => '/users/some-user/received_events',
        },
    );

    foreach my $test (@tests) {
        my $method = $test->{method};
        my $path   = $test->{path};
        my @params = @{ $test->{params} || [] };
        my $result = $obj->$method(@params);
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, $path, 'HTTP path';
        is $result->request->content, '', 'HTTP body';
    }

    is $obj->user_performed( user => 'foo', public => 1 )->request->uri->path, '/users/foo/events/public', 'HTTP path';
    is $obj->user_received( user => 'foo', public => 1 )->request->uri->path, '/users/foo/received_events/public', 'HTTP path';
}

done_testing;
