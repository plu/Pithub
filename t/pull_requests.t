#!perl

use strict;
use warnings;

use JSON::MaybeXS        qw( JSON );
use Pithub::PullRequests ();
use Test::Differences    qw( eq_or_diff );
use Test::Exception;    # throws_ok
use Test::More import => [qw( done_testing is isa_ok ok )];

use lib 't/lib';
use Pithub::Test::Factory ();

# Pithub::PullRequests->commits
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

    throws_ok { $obj->commits } qr{Missing key in parameters: pull_request_id}, 'No parameters';

    isa_ok $obj, 'Pithub::PullRequests';

    {
        my $result = $obj->commits( pull_request_id => 1 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/1/commits', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests->create
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create( data => { foo => 'bar' } ); } qr{Access token required for: POST /repos/foo/bar/pulls}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->create(
            data => {
                base  => 'master',
                body  => 'Please pull this in!',
                head  => 'octocat:new-feature',
                title => 'Amazing new feature',
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          { 'body' => 'Please pull this in!', 'base' => 'master', 'head' => 'octocat:new-feature', 'title' => 'Amazing new feature' }, 'HTTP body';
    }
}

# Pithub::PullRequests->files
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

    throws_ok { $obj->files } qr{Missing key in parameters: pull_request_id}, 'No parameters';

    isa_ok $obj, 'Pithub::PullRequests';

    {
        my $result = $obj->files( pull_request_id => 1 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/1/files', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests->get
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

    throws_ok { $obj->get } qr{Missing key in parameters: pull_request_id}, 'No parameters';

    isa_ok $obj, 'Pithub::PullRequests';

    {
        my $result = $obj->get( pull_request_id => 1 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/1', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests->is_merged
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

    throws_ok { $obj->is_merged } qr{Missing key in parameters: pull_request_id}, 'No parameters';

    isa_ok $obj, 'Pithub::PullRequests';

    {
        my $result = $obj->is_merged( pull_request_id => 1 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/1/merge', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests->merge
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests';

    throws_ok { $obj->merge } qr{Missing key in parameters: pull_request_id}, 'No parameters';
    throws_ok { $obj->merge( pull_request_id => 123 ); } qr{Access token required for: PUT /repos/foo/bar/pulls/123/merge}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->merge( pull_request_id => 123 );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/123/merge', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests->update
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests';

    throws_ok { $obj->update } qr{Missing key in parameters: pull_request_id}, 'No parameter';
    throws_ok { $obj->update( pull_request_id => 1 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( pull_request_id => 5, data => { foo => 'bar' } ); } qr{Access token required for: PATCH /repos/foo/bar/pulls/5}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            pull_request_id => 123,
            data            => {
                base  => 'master',
                body  => 'Please pull this in!',
                head  => 'octocat:new-feature',
                title => 'Amazing new feature',
            }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          { 'body' => 'Please pull this in!', 'base' => 'master', 'head' => 'octocat:new-feature', 'title' => 'Amazing new feature' }, 'HTTP body';
    }
}

# Pithub::PullRequests::Comments->create
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Comments';

    throws_ok { $obj->create } qr{Missing key in parameters: pull_request_id}, 'No parameters';
    throws_ok { $obj->create( pull_request_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create( pull_request_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok {
        $obj->create( pull_request_id => 123, data => { foo => 'bar' } );
    }
    qr{Access token required for: POST /repos/foo/bar/pulls/123/comments}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->create( pull_request_id => 123, data => { body => 'some comment' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/123/comments', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'some comment' }, 'HTTP body';
    }
}

# Pithub::PullRequests::Comments->delete
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Comments';

    throws_ok { $obj->delete } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->delete( comment_id => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/pulls/comments/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( comment_id => 456 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/comments/456', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests::Comments->get
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Comments';

    throws_ok { $obj->get } qr{Missing key in parameters: comment_id}, 'No parameters';

    {
        my $result = $obj->get( comment_id => 456 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/comments/456', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests::Comments->list
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Comments';

    throws_ok { $obj->list } qr{Missing key in parameters: pull_request_id}, 'No parameters';

    {
        my $result = $obj->list( pull_request_id => 456 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/456/comments', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests::Comments->update
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Comments';

    throws_ok { $obj->update } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->update( comment_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( comment_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok {
        $obj->update( comment_id => 123, data => { foo => 'bar' } );
    }
    qr{Access token required for: PATCH /repos/foo/bar/pulls/comments/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->update( comment_id => 123, data => { body => 'some comment' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/comments/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'some comment' }, 'HTTP body';
    }
}

# Pithub::PullRequests::Reviewers->delete
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Reviewers', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Reviewers';

    throws_ok { $obj->delete } qr{Missing key in parameters: pull_request_id}, 'No parameters';
    throws_ok { $obj->delete( pull_request_id => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/pulls/123/requested_reviewers}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( pull_request_id => 456 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/456/requested_reviewers', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests::Reviewers->list
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Reviewers', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Reviewers';

    throws_ok { $obj->list } qr{Missing key in parameters: pull_request_id}, 'No parameters';

    {
        my $result = $obj->list( pull_request_id => 456 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/456/requested_reviewers', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, q{}, 'HTTP body';
    }
}

# Pithub::PullRequests::Reviewers->update
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::PullRequests::Reviewers', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::PullRequests::Reviewers';

    throws_ok { $obj->update } qr{Missing key in parameters: pull_request_id}, 'No parameters';
    throws_ok { $obj->update( pull_request_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( pull_request_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok {
        $obj->update( pull_request_id => 123, data => { reviewers => ['bar'] } );
    }
    qr{Access token required for: POST /repos/foo/bar/pulls/123/requested_reviewers}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->update( pull_request_id => 123, data => { reviewers => ['baz'] } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/pulls/123/requested_reviewers', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'reviewers' => ['baz'] }, 'HTTP body';
    }
}

done_testing;
