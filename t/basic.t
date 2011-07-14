use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Pithub::Test::UA;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

my %accessors = (
    gists => {
        isa       => 'Pithub::Gists',
        accessors => { comments => 'Pithub::Gists::Comments' }
    },
    git_data => {
        isa       => 'Pithub::GitData',
        accessors => {
            blobs      => 'Pithub::GitData::Blobs',
            commits    => 'Pithub::GitData::Commits',
            references => 'Pithub::GitData::References',
            tags       => 'Pithub::GitData::Tags',
            trees      => 'Pithub::GitData::Trees',
        }
    },
    issues => {
        isa       => 'Pithub::Issues',
        accessors => {
            comments   => 'Pithub::Issues::Comments',
            events     => 'Pithub::Issues::Events',
            labels     => 'Pithub::Issues::Labels',
            milestones => 'Pithub::Issues::Milestones',
        }
    },
    orgs => {
        isa       => 'Pithub::Orgs',
        accessors => {
            members => 'Pithub::Orgs::Members',
            teams   => 'Pithub::Orgs::Teams',
        }
    },
    pull_requests => {
        isa       => 'Pithub::PullRequests',
        accessors => { comments => 'Pithub::PullRequests::Comments' }
    },
    repos => {
        isa       => 'Pithub::Repos',
        accessors => {
            collaborators => 'Pithub::Repos::Collaborators',
            commits       => 'Pithub::Repos::Commits',
            downloads     => 'Pithub::Repos::Downloads',
            forks         => 'Pithub::Repos::Forks',
            keys          => 'Pithub::Repos::Keys',
            watching      => 'Pithub::Repos::Watching',
        }
    },
    users => {
        isa       => 'Pithub::Users',
        accessors => {
            emails    => 'Pithub::Users::Emails',
            followers => 'Pithub::Users::Followers',
            keys      => 'Pithub::Users::Keys',
        }
    },
);

{
    my $p = Pithub->new( user => 'plu', repo => 'Pithub', token => 123 );

    isa_ok $p, 'Pithub';

    while ( my ( $main_accessor, $sub ) = each %accessors ) {
        isa_ok $p->$main_accessor, $sub->{isa};
        while ( my ( $sub_accessor, $isa ) = each %{ $sub->{accessors} } ) {
            isa_ok $p->$main_accessor->$sub_accessor, $isa;
            is $p->$main_accessor->user, 'plu', "Parameter user was curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->user, 'plu', "Parameter user was curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->repo, 'Pithub', "Parameter repo was curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->repo, 'Pithub', "Parameter repo was curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->token, 123, "Parameter token was curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->token, 123, "Parameter token was curried to ${main_accessor}->${sub_accessor}";
        }
    }
}

# Once again, this time we do not currie the user, repo and token attribute
{
    my $p = Pithub->new;

    while ( my ( $main_accessor, $sub ) = each %accessors ) {
        isa_ok $p->$main_accessor, $sub->{isa};
        while ( my ( $sub_accessor, $isa ) = each %{ $sub->{accessors} } ) {
            isa_ok $p->$main_accessor->$sub_accessor, $isa;
            is $p->$main_accessor->user, undef, "Parameter user was not curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->user, undef, "Parameter user was not curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->repo, undef, "Parameter repo was not curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->repo, undef, "Parameter repo was not curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->token, undef, "Parameter token was not curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->token, undef, "Parameter token was curried to ${main_accessor}->${sub_accessor}";
        }
    }
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );

    isa_ok $p, 'Pithub';

    throws_ok { $p->request } qr{Missing mandatory key in parameters: method}, 'Not given any parameters';
    throws_ok { $p->request( method => 'GET' ) } qr{Missing mandatory key in parameters: path}, 'Parameter path missing';
    throws_ok { $p->request( method => 'xxx', path => '/bar' ) } qr{Invalid method: xxx}, 'Not a valid HTTP method';
    lives_ok { $p->request( method => 'GET', path => 'bar' ) } 'Correct parameters do not throw an exception';

    throws_ok { $p->request( method => 'GET', path => '/bar', options => [] ) }
    qr{The parameter \$options must be a hashref},
      '$options must be a hashref';

    throws_ok { $p->request( method => 'GET', path => '/bar', options => { prepare_request => 1 } ) }
    qr{The key prepare_request in the \$options hashref must be a coderef},
      'prepare_request must be a coderef';

    lives_ok { $p->request( method => 'GET', path => 'bar', options => {} ) } 'Empty options hashref';

    my $result       = $p->request( method => 'GET', path => '/bar' );
    my $response     = $result->response;
    my $http_request = $response->http_request;

    isa_ok $result,       'Pithub::Result';
    isa_ok $response,     'Pithub::Response';
    isa_ok $http_request, 'HTTP::Request';

    is $http_request->content, '', 'The data hashref is undef';

    is $http_request->uri->path, '/bar', 'The HTTP path was set in the HTTP::Request object';
    is $http_request->header('Authorization'), undef, 'Authorization header was not set in the HTTP::Request object';

    is $http_request->header('Content-Length'), 0, 'Content-Length header was set';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    $p->token('123');
    my $request = $p->request( method => 'POST', path => '/foo', data => { some => 'data' } )->request;
    eq_or_diff $request->content, '{"some":"data"}', 'The JSON content was set in the request object';
    is $request->header('Authorization'), 'token 123', 'Authorization header was set in the HTTP::Request object';
    ok $p->clear_token, 'Access token clearer';
    is $p->token, undef, 'No token set anymore';
    $request = $p->request( method => 'POST', path => '/foo', data => { some => 'data' } )->request;
    is $request->header('Authorization'), undef, 'Authorization header was not set in the HTTP::Request object';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    my $result = $p->request( method => 'GET', path => '/error/notfound' );

    is $result->code,    404, 'HTTP status is 404';
    is $result->success, '',  'Unsuccessful response';

    ok $result->raw_content, 'Has raw JSON content';
    is ref( $result->content ), 'HASH', 'Has decoded JSON hashref';

    is $result->content->{message}, 'Not Found', 'Attribute exists in response: message';

    is $result->ratelimit,           5000, 'Accessor to X-RateLimit-Limit header';
    is $result->ratelimit_remaining, 4962, 'Accessor to X-RateLimit-Remaining header';

    is $result->count, 0, 'Count accessor';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    my $result = $p->users->followers->list( user => 'miyagawa' );

    is $result->count,          30,                                                        'Count accessor';
    is $result->first_page_uri, undef,                                                     'First page link on first page';
    is $result->prev_page_uri,  undef,                                                     'First page link on first page';
    is $result->next_page_uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'Next page link on first page';
    is $result->last_page_uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page link on first page';

    is $result->first_page, undef, 'We are on first page already';
    is $result->prev_page,  undef, 'No prev page on the first page';
    is $result->next_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=2',  'Next page call';
    is $result->last_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=26', 'Last page call';

    is $result->get_page(42)->request->uri, 'https://api.github.com/users/miyagawa/followers?page=42',
      'URI for get_page is generated, no matter if it exists or not';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    my $result = $p->users->followers->list( user => 'miyagawa' )->get_page(3);

    is $result->first_page_uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page link on third page';
    is $result->prev_page_uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'First page link no third page';
    is $result->next_page_uri,  'https://api.github.com/users/miyagawa/followers?page=4',  'Next page link no third page';
    is $result->last_page_uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page link no third page';

    is $result->first_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page call';
    is $result->prev_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'Prev page call';
    is $result->next_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=4',  'Next page call';
    is $result->last_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page call';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    my $result = $p->users->followers->list( user => 'miyagawa' )->get_page(26);

    is $result->first_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page call';
    is $result->prev_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=25', 'Prev page call';
    is $result->next_page, undef, 'No next page on the last page';
    is $result->last_page, undef, 'We are on last page already';

    is $result->get_page(42)->request->uri, 'https://api.github.com/users/miyagawa/followers?page=42',
      'URI for get_page is generated, no matter if it exists or not';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new, per_page => 1 );
    my $result = $p->users->followers->list( user => 'miyagawa' );

    is $result->next_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=2&per_page=1',   'Next page call';
    is $result->last_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=769&per_page=1', 'Last page call';
    is $result->prev_page,  undef, 'No prev page on the first page';
    is $result->first_page, undef, 'We are on first page already';

    is $result->get_page(42)->request->uri, 'https://api.github.com/users/miyagawa/followers?page=42&per_page=1',
      'URI for get_page is generated, no matter if it exists or not';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    my $result = $p->users->get( user => 'plu' );

    is $result->first_page, undef, 'First page call';
    is $result->prev_page,  undef, 'Prev page call';
    is $result->next_page,  undef, 'No next page on the last page';
    is $result->last_page,  undef, 'We are on last page already';

    is $result->get_page(1), undef, 'No page 1';
    is $result->count, 1, 'Count accessor';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new, jsonp_callback => 'foo' );
    my $result = $p->request( method => 'GET', path => '/foo' );
    is $result->request->uri->query, 'callback=foo', 'The callback parameter was set';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    my $result = $p->request( method => 'GET', path => '/orgs/CPAN-API/repos' );

    my @expectations = (
        'https://github.com/CPAN-API/cpan-api',        'https://github.com/CPAN-API/search-metacpan-org',
        'https://github.com/CPAN-API/cpanvote-server', 'https://github.com/CPAN-API/cpanvote-db',
        'https://github.com/CPAN-API/metacpan-web',
    );

    is $result->first->{html_url}, $expectations[0], 'Accesor first on an arrayref content';

    while ( my $row = $result->next ) {
        is $row->{html_url}, shift(@expectations), 'Iterator next';
    }

    is scalar(@expectations), 0, 'Consumed all rows';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new );
    my $result = $p->request( method => 'GET', path => '/users/plu' );

    my $row = $result->next;
    is $row->{id}, 31597, 'Row data found';

    eq_or_diff $result->first, $row, 'Accessor first on a hashref content';

    is $result->next, undef, 'There is only one record';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new, per_page => 15 );
    my $result = $p->users->followers->list( user => 'plu' );
    $result->auto_pagination(1);
    my @followers = ();
    while ( my $row = $result->next ) {
        push @followers, $row;
    }
    is scalar(@followers), 54, 'Automatically paginate through four pages';
}

{
    my $p = Pithub->new( ua => Pithub::Test::UA->new, per_page => 15, auto_pagination => 1 );
    my $result = $p->users->followers->list( user => 'plu' );
    my @followers = ();
    while ( my $row = $result->next ) {
        push @followers, $row;
    }
    is scalar(@followers), 54, 'Automatically paginate through four pages';
}

done_testing;
