use FindBin;
use lib "$FindBin::Bin/lib";
use JSON;
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues');
    use_ok('Pithub::Issues::Assignees');
    use_ok('Pithub::Issues::Comments');
    use_ok('Pithub::Issues::Events');
    use_ok('Pithub::Issues::Labels');
    use_ok('Pithub::Issues::Milestones');
}

# Pithub::Issues->create
{
    my $obj = Pithub::Test->create( 'Pithub::Issues', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { foo => 123 } ); } qr{Access token required for: POST /repos/foo/bar/issues}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->create(
            data => {
                assignee  => 'octocat',
                body      => "I'm having a problem with this.",
                labels    => [ 'Label1', 'Label2' ],
                milestone => 1,
                title     => 'Found a bug'
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          {
            'body'      => 'I\'m having a problem with this.',
            'assignee'  => 'octocat',
            'milestone' => 1,
            'title'     => 'Found a bug',
            'labels'    => [ 'Label1', 'Label2' ]
          },
          'HTTP body';
    }
}

# Pithub::Issues->get
{
    my $obj = Pithub::Test->create( 'Pithub::Issues', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues';

    throws_ok { $obj->get } qr{Missing key in parameters: issue_id}, 'No parameters';

    {
        my $result = $obj->get( issue_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues->list
{
    {
        my $obj = Pithub::Test->create( 'Pithub::Issues', user => 'foo', repo => 'bar' );
        isa_ok $obj, 'Pithub::Issues';
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '',    'HTTP body';
        is $result->prev_page_uri, undef, 'No prev link header set';
    }

    {
        my $obj = Pithub::Test->create('Pithub::Issues');
        isa_ok $obj, 'Pithub::Issues';
        throws_ok { $obj->list; } qr{Access token required for: GET /issues}, 'Token required';
        ok $obj->token(123), 'Token set';
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/issues', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues->update
{
    my $obj = Pithub::Test->create( 'Pithub::Issues', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues';

    throws_ok { $obj->update } qr{Missing key in parameters: issue_id}, 'No parameters';
    throws_ok { $obj->update( issue_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->update( issue_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->update( issue_id => 123, data => { foo => 123 } ); } qr{Access token required for: PATCH /repos/foo/bar/issues/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            issue_id => 123,
            data     => {
                assignee  => 'octocat',
                body      => "I'm having a problem with this.",
                labels    => [ 'Label1', 'Label2' ],
                milestone => 1,
                state     => 'open',
                title     => 'Found a bug'
            }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          {
            'body'      => 'I\'m having a problem with this.',
            'assignee'  => 'octocat',
            'milestone' => 1,
            'title'     => 'Found a bug',
            'labels'    => [ 'Label1', 'Label2' ],
            'state'     => 'open'
          },
          'HTTP body';
    }
}

# Pithub::Issues::Assignees->check
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Assignees', user => 'foo', repo => 'bar' );

    throws_ok { $obj->check } qr{Missing key in parameters: assignee}, 'No parameters';

    isa_ok $obj, 'Pithub::Issues::Assignees';

    {
        my $result = $obj->check( assignee => 'plu' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/assignees/plu', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Assignees->list
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Assignees', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Assignees';

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/assignees', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Comments->create
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Comments';

    throws_ok { $obj->create } qr{Missing key in parameters: issue_id}, 'No parameters';
    throws_ok { $obj->create( issue_id => 1 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create( issue_id => 1, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( issue_id => 1, data => { foo => 123 } ); } qr{Access token required for: POST /repos/foo/bar/issues/1/comments\s+},
      'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->create(
            issue_id => 123,
            data     => { body => 'comment' }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/comments', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'comment' }, 'HTTP body';
    }
}

# Pithub::Issues::Comments->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Comments';

    throws_ok { $obj->delete } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->delete( comment_id => 123 ); } qr{DELETE /repos/foo/bar/issues/comments/123\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( comment_id => 123, );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/comments/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Comments->get
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Comments';

    throws_ok { $obj->get } qr{Missing key in parameters: comment_id}, 'No parameters';

    {
        my $result = $obj->get( comment_id => 123, );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/comments/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Comments->list
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Comments';

    throws_ok { $obj->list } qr{Missing key in parameters: issue_id}, 'No parameters';

    {
        my $result = $obj->list( issue_id => 123, );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/comments', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Comments->update
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Comments', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Comments';

    throws_ok { $obj->update } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->update( comment_id => 1 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( comment_id => 1, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->update( comment_id => 1, data => { foo => 123 } ); } qr{PATCH /repos/foo/bar/issues/comments/1\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            comment_id => 123,
            data       => { body => 'comment' }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/comments/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'comment' }, 'HTTP body';
    }
}

# Pithub::Issues::Events->get
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Events', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Events';

    throws_ok { $obj->get } qr{Missing key in parameters: event_id}, 'No parameters';

    {
        my $result = $obj->get( event_id => 123, );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/events/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Events->list
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Events', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Events';

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/events', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->list( issue_id => 123, );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/events', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Labels->add
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    throws_ok { $obj->add } qr{Missing key in parameters: issue_id}, 'No parameters';
    throws_ok { $obj->add( issue_id => 1 ) } qr{Missing key in parameters: data \(arrayref\)}, 'No data parameter';
    throws_ok { $obj->add( issue_id => 1, data => 5 ) } qr{Missing key in parameters: data \(arrayref\)}, 'Wrong data parameter';
    throws_ok { $obj->add( issue_id => 123, data => [qw(label1 label2)] ); }
    qr{Access token required for: POST /repos/foo/bar/issues/123/labels\s+},
      'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->add(
            issue_id => 123,
            data     => [qw(label1 label2)],
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/labels', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), [ 'label1', 'label2' ], 'HTTP body';
    }
}

# Pithub::Issues::Labels->create
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { name => 'foo' } ); } qr{Access token required for: POST /repos/foo/bar/labels\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->create(
            data => {
                name  => 'label1',
                color => 'FFFFFF',
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/labels', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'color' => 'FFFFFF', 'name' => 'label1' }, 'HTTP body';
    }
}

# Pithub::Issues::Labels->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    throws_ok { $obj->delete } qr{Missing key in parameters: label}, 'No parameters';
    throws_ok { $obj->delete( label => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/labels/123\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( label => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/labels/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Labels->get
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    throws_ok { $obj->get } qr{Missing key in parameters: label}, 'No parameters';

    {
        my $result = $obj->get( label => 'bug' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/labels/bug', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Labels->list
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/labels', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->list( issue_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/labels', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->list( milestone_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/milestones/123/labels', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Labels->remove
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    throws_ok { $obj->remove } qr{Missing key in parameters: issue_id}, 'No parameters';
    throws_ok { $obj->remove( issue_id => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/issues/123/labels\s+}, 'Token required';
    throws_ok { $obj->remove( issue_id => 123, label => 456 ); } qr{Access token required for: DELETE /repos/foo/bar/issues/123/labels/456\s+},
      'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->remove( issue_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/labels', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->remove( issue_id => 123, label => 456 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/labels/456', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Labels->replace
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    throws_ok { $obj->replace } qr{Missing key in parameters: issue_id}, 'No parameters';
    throws_ok { $obj->replace( issue_id => 1 ) } qr{Missing key in parameters: data \(arrayref\)}, 'No data parameter';
    throws_ok { $obj->replace( issue_id => 1, data => 5 ) } qr{Missing key in parameters: data \(arrayref\)}, 'Wrong data parameter';
    throws_ok { $obj->replace( issue_id => 123, data => [qw(label1 label2)] ); }
    qr{Access token required for: PUT /repos/foo/bar/issues/123/labels\s+},
      'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->replace(
            issue_id => 123,
            data     => [qw(label1 label2)],
        );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/issues/123/labels', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), [ 'label1', 'label2' ], 'HTTP body';
    }
}

# Pithub::Issues::Labels->update
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Labels';

    throws_ok { $obj->update } qr{Missing key in parameters: label}, 'No parameters';
    throws_ok { $obj->update( label => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->update( label => 123, data => { name => 'foo' } ); } qr{Access token required for: PATCH /repos/foo/bar/labels/123\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            label => 123,
            data  => {
                name  => 'label2',
                color => 'FF0000',
            }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/labels/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'color' => 'FF0000', 'name' => 'label2' }, 'HTTP body';
    }
}

# Pithub::Issues::Milestones->create
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Milestones';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { name => 'foo' } ); } qr{Access token required for: POST /repos/foo/bar/milestones\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->create(
            data => {
                description => 'String',
                due_on      => 'Time',
                state       => 'open or closed',
                title       => 'String'
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/milestones', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'title' => 'String', 'due_on' => 'Time', 'description' => 'String', 'state' => 'open or closed' },
          'HTTP body';
    }
}

# Pithub::Issues::Milestones->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Milestones';

    throws_ok { $obj->delete } qr{Missing key in parameters: milestone_id}, 'No parameters';
    throws_ok { $obj->delete( milestone_id => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/milestones/123\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( milestone_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/milestones/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Milestones->get
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Milestones';

    throws_ok { $obj->get } qr{Missing key in parameters: milestone_id}, 'No parameters';

    {
        my $result = $obj->get( milestone_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/milestones/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Milestones->list
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Milestones';

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/milestones', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Issues::Milestones->update
{
    my $obj = Pithub::Test->create( 'Pithub::Issues::Milestones', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Issues::Milestones';

    throws_ok { $obj->update } qr{Missing key in parameters: milestone_id}, 'No parameters';
    throws_ok { $obj->update( milestone_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->update( milestone_id => 123, data => { name => 'foo' } ); }
    qr{Access token required for: PATCH /repos/foo/bar/milestones/123\s+},
      'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            milestone_id => 123,
            data         => {
                description => 'String',
                due_on      => 'Time',
                state       => 'open or closed',
                title       => 'String'
            }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/milestones/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'title' => 'String', 'due_on' => 'Time', 'description' => 'String', 'state' => 'open or closed' },
          'HTTP body';
    }
}

done_testing;
