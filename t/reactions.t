#!perl

use strict;
use warnings;

use JSON::MaybeXS     qw( JSON );
use Pithub::Reactions ();
use Test::Differences qw( eq_or_diff );
use Test::Exception;    # throws_ok
use Test::More import => [qw( done_testing is isa_ok ok subtest )];

use lib 't/lib';
use Pithub::Test          qw( uri_is );
use Pithub::Test::Factory ();

my @targets = (
    {
        name   => 'commit_comment',
        id_key => 'comment_id',
        path   => '/repos/foo/bar/comments/42/reactions',
    },
    {
        name   => 'issue',
        id_key => 'issue_id',
        path   => '/repos/foo/bar/issues/42/reactions',
    },
    {
        name   => 'issue_comment',
        id_key => 'comment_id',
        path   => '/repos/foo/bar/issues/comments/42/reactions',
    },
    {
        name   => 'pull_request_comment',
        id_key => 'comment_id',
        path   => '/repos/foo/bar/pulls/comments/42/reactions',
    },
    {
        name   => 'release',
        id_key => 'release_id',
        path   => '/repos/foo/bar/releases/42/reactions',
    },
);

foreach my $target (@targets) {
    my $id_key = $target->{id_key};
    my $path   = $target->{path};

    subtest "list_for_$target->{name}" => sub {
        my $method = "list_for_$target->{name}";
        my $obj    = Pithub::Test::Factory->create(
            'Pithub::Reactions',
            user => 'foo', repo => 'bar'
        );
        isa_ok $obj, 'Pithub::Reactions';

        throws_ok { $obj->$method }
        qr{Missing key in parameters: $id_key}, 'No parameters';

        my $result = $obj->$method( $id_key => 42 );
        is $result->request->method,    'GET', 'HTTP method';
        is $result->request->uri->path, $path, 'HTTP path';
        is $result->request->content,   q{},   'HTTP body';

        $result = $obj->$method(
            $id_key => 42,
            params  => { content => 'heart', per_page => 5, page => 2 },
        );
        uri_is $result->request->uri,
            "https://api.github.com$path?content=heart&per_page=5&page=2",
            'content, per_page and page go in the query string';

        $result = Pithub::Test::Factory->create('Pithub::Reactions')
            ->$method( user => 'foo', repo => 'bar', $id_key => 42 );
        is $result->request->uri->path, $path,
            'user and repo can be passed per call';
    };

    subtest "create_for_$target->{name}" => sub {
        my $method = "create_for_$target->{name}";
        my $obj    = Pithub::Test::Factory->create(
            'Pithub::Reactions',
            user => 'foo', repo => 'bar'
        );

        throws_ok { $obj->$method }
        qr{Missing key in parameters: $id_key}, 'No parameters';
        throws_ok { $obj->$method( $id_key => 42 ) }
        qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
        throws_ok { $obj->$method( $id_key => 42, data => {} ) }
        qr{Invalid content\. Valid values: \+1, -1, laugh}, 'No content';
        throws_ok {
            $obj->$method( $id_key => 42, data => { content => 'thumbsup' } )
        }
        qr{Invalid content}, 'Content outside the enumeration';
        throws_ok {
            $obj->$method( $id_key => 42, data => { content => '+1' } )
        }
        qr{Access token required for: POST \Q$path\E}, 'Token required';

        ok $obj->token(123), 'Token set';

        foreach
            my $content (qw( +1 -1 laugh confused heart hooray rocket eyes ))
        {
            my $result = $obj->$method(
                $id_key => 42,
                data    => { content => $content }
            );
            is $result->request->method,    'POST', "HTTP method ($content)";
            is $result->request->uri->path, $path,  "HTTP path ($content)";
            eq_or_diff JSON->new->decode( $result->request->content ),
                { content => $content }, "HTTP body ($content)";
        }
    };

    subtest "delete_for_$target->{name}" => sub {
        my $method = "delete_for_$target->{name}";
        my $obj    = Pithub::Test::Factory->create(
            'Pithub::Reactions',
            user => 'foo', repo => 'bar'
        );

        throws_ok { $obj->$method }
        qr{Missing key in parameters: reaction_id}, 'No parameters';
        throws_ok { $obj->$method( reaction_id => 7 ) }
        qr{Missing key in parameters: $id_key}, 'No target id';
        throws_ok { $obj->$method( $id_key => 42, reaction_id => 7 ) }
        qr{Access token required for: DELETE \Q$path\E/7}, 'Token required';

        ok $obj->token(123), 'Token set';

        my $result = $obj->$method( $id_key => 42, reaction_id => 7 );
        is $result->request->method,    'DELETE',  'HTTP method';
        is $result->request->uri->path, "$path/7", 'HTTP path';
        is $result->request->content,   q{},       'HTTP body';
    };
}

done_testing;
