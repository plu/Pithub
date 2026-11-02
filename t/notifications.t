#!perl

use strict;
use warnings;

use JSON::MaybeXS     qw( JSON );
use Test::Differences qw( eq_or_diff );
use Test::Exception;    # throws_ok
use Test::More import => [qw( done_testing is isa_ok ok subtest use_ok )];

use lib 't/lib';
use Pithub::Test          qw( uri_is );
use Pithub::Test::Factory ();

BEGIN {
    use_ok('Pithub::Notifications');
}

sub notifications {
    return Pithub::Test::Factory->create( 'Pithub::Notifications', @_ );
}

subtest 'Pithub::Notifications->delete_thread_subscription' => sub {
    my $obj = notifications();
    isa_ok $obj, 'Pithub::Notifications';

    throws_ok { $obj->delete_thread_subscription }
    qr{Missing key in parameters: thread_id}, 'No parameters';
    throws_ok { $obj->delete_thread_subscription( thread_id => 42 ) }
    qr{Access token required for: DELETE /notifications/threads/42/subscription\s+},
        'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->delete_thread_subscription( thread_id => 42 );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/notifications/threads/42/subscription',
        'HTTP path';
    is $result->request->content, q{}, 'HTTP body';
};

subtest 'Pithub::Notifications->get' => sub {
    my $obj = notifications();

    throws_ok { $obj->get } qr{Missing key in parameters: thread_id},
        'No parameters';
    throws_ok { $obj->get( thread_id => 42 ) }
    qr{Access token required for: GET /notifications/threads/42\s+},
        'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->get( thread_id => 42 );
    is $result->request->method,    'GET', 'HTTP method';
    is $result->request->uri->path, '/notifications/threads/42', 'HTTP path';
    is $result->request->content,   q{},                         'HTTP body';
};

subtest 'Pithub::Notifications->get_thread_subscription' => sub {
    my $obj = notifications();

    throws_ok { $obj->get_thread_subscription }
    qr{Missing key in parameters: thread_id}, 'No parameters';
    throws_ok { $obj->get_thread_subscription( thread_id => 42 ) }
    qr{Access token required for: GET /notifications/threads/42/subscription\s+},
        'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->get_thread_subscription( thread_id => 42 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/notifications/threads/42/subscription',
        'HTTP path';
    is $result->request->content, q{}, 'HTTP body';
};

subtest 'Pithub::Notifications->list' => sub {
    my $obj = notifications();

    throws_ok { $obj->list }
    qr{Access token required for: GET /notifications\s+},
        'Token required for the notifications of the user';
    throws_ok { $obj->list( user => 'foo', repo => 'bar' ) }
    qr{Access token required for: GET /repos/foo/bar/notifications\s+},
        'Token required for the notifications of a repo';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->list(
            params => {
                all           => 'true',
                participating => 'false',
                since         => '2026-01-01T00:00:00Z',
            },
        );
        is $result->request->method, 'GET', 'HTTP method';
        uri_is $result->request->uri,
            'https://api.github.com/notifications?all=true&participating=false&per_page=100&since=2026-01-01T00%3A00%3A00Z',
            'HTTP path and query';
        is $result->request->content, q{}, 'HTTP body';
    }

    {
        my $result = $obj->list( user => 'foo', repo => 'bar' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/notifications',
            'HTTP path';
        is $result->request->content, q{}, 'HTTP body';
    }

    {
        my $repo_obj = notifications( user => 'foo', repo => 'bar' );
        $repo_obj->token(123);
        is $repo_obj->list->request->uri->path,
            '/repos/foo/bar/notifications',
            'user and repo attributes select the notifications of the repo';
    }

    {
        # A poller sends If-Modified-Since and reads the response headers.
        # The participating param keeps this URI apart from the requests
        # above in the shared cache.
        my $since = 'Thu, 01 Jan 2026 00:00:00 GMT';
        $obj->ua->add_response('notifications.GET');
        my $result = $obj->list(
            headers => { 'If-Modified-Since' => $since },
            params  => { participating       => 'true' },
        );
        is $result->request->header('If-Modified-Since'), $since,
            'If-Modified-Since request header sent';
        is $result->code, 200, 'HTTP status';
        is $result->response->header('Last-Modified'),
            'Fri, 02 Jan 2026 00:00:00 GMT', 'Last-Modified response header';
        is $result->response->header('X-Poll-Interval'), 60,
            'X-Poll-Interval response header';
    }
};

subtest 'Pithub::Notifications->mark_as_read' => sub {
    my $obj  = notifications();
    my $json = JSON->new;

    throws_ok { $obj->mark_as_read }
    qr{Access token required for: PUT /notifications\s+},
        'Token required for the notifications of the user';
    throws_ok { $obj->mark_as_read( user => 'foo', repo => 'bar' ) }
    qr{Access token required for: PUT /repos/foo/bar/notifications\s+},
        'Token required for the notifications of a repo';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->mark_as_read;
        is $result->request->method,    'PUT',            'HTTP method';
        is $result->request->uri->path, '/notifications', 'HTTP path';
        is $result->request->content,   q{},              'HTTP body';
    }

    {
        my $data   = { last_read_at => '2026-01-01T00:00:00Z' };
        my $result = $obj->mark_as_read(
            user => 'foo',
            repo => 'bar',
            data => $data,
        );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/notifications',
            'HTTP path';
        eq_or_diff $json->decode( $result->request->content ), $data,
            'HTTP body';
    }
};

subtest 'Pithub::Notifications->mark_thread_as_done' => sub {
    my $obj = notifications();

    throws_ok { $obj->mark_thread_as_done }
    qr{Missing key in parameters: thread_id}, 'No parameters';
    throws_ok { $obj->mark_thread_as_done( thread_id => 42 ) }
    qr{Access token required for: DELETE /notifications/threads/42\s+},
        'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->mark_thread_as_done( thread_id => 42 );
    is $result->request->method,    'DELETE', 'HTTP method';
    is $result->request->uri->path, '/notifications/threads/42', 'HTTP path';
    is $result->request->content,   q{},                         'HTTP body';
};

subtest 'Pithub::Notifications->mark_thread_as_read' => sub {
    my $obj = notifications();

    throws_ok { $obj->mark_thread_as_read }
    qr{Missing key in parameters: thread_id}, 'No parameters';
    throws_ok { $obj->mark_thread_as_read( thread_id => 42 ) }
    qr{Access token required for: PATCH /notifications/threads/42\s+},
        'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->mark_thread_as_read( thread_id => 42 );
    is $result->request->method,    'PATCH', 'HTTP method';
    is $result->request->uri->path, '/notifications/threads/42', 'HTTP path';
    is $result->request->content,   q{},                         'HTTP body';
};

subtest 'Pithub::Notifications->set_thread_subscription' => sub {
    my $obj  = notifications();
    my $json = JSON->new;

    throws_ok { $obj->set_thread_subscription }
    qr{Missing key in parameters: thread_id}, 'No parameters';
    throws_ok { $obj->set_thread_subscription( thread_id => 42 ) }
    qr{Access token required for: PUT /notifications/threads/42/subscription\s+},
        'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->set_thread_subscription(
        thread_id => 42,
        data      => { ignored => JSON->true },
    );
    is $result->request->method, 'PUT', 'HTTP method';
    is $result->request->uri->path, '/notifications/threads/42/subscription',
        'HTTP path';
    eq_or_diff $json->decode( $result->request->content ),
        { ignored => JSON->true }, 'HTTP body';
};

done_testing;
