package Pithub::Base;

# ABSTRACT: Github v3 base class for all Pithub modules

use Moo;
use Carp qw(croak);
use HTTP::Headers;
use HTTP::Request;
use JSON;
use LWP::UserAgent;
use Pithub::Result;
use URI;

with 'Pithub::Result::SharedCache';

=head1 DESCRIPTION

All L<Pithub> L<modules|Pithub/MODULES> inherit from
L<Pithub::Base>, even L<Pithub> itself. So all
L<attributes|/ATTRIBUTES> listed here can either be set in the
constructor or via the setter on the objects.

If any attribute is set on a L<Pithub> object, it gets
automatically set on objects, that get created by a method call on
the L<Pithub> object. This is very convenient for attributes like
the L</token> or the L</user> and L</repo> attributes.

The L</user> and L</repo> attributes are special: They get even
set on method calls that require B<both> of them. This is to reduce
verbosity, especially if you want to do a lot of things on the
same repo. This also works for other objects: If you create an
object of L<Pithub::Repos> where you set the L</user> and L</repo>
attribute in the constructor, this will also be set once you
get to the L<Pithub::Repos::Keys> object via the C<< keys >> method.

Examples:

    # just to demonstrate the "magic"
    print Pithub->new( user => 'plu' )->repos->user;          # plu
    print Pithub::Repos->new( user => 'plu' )->keys->user;    # plu

    # and now some real use cases
    my $p = Pithub->new( user => 'plu', repo => 'Pithub' );
    my $r = $p->repos;

    print $r->user;    # plu
    print $r->repo;    # pithub

    # usually you would do
    print $r->get( user => 'plu', repo => 'Pithub' )->content->{html_url};

    # but since user + repo has been set already
    print $r->get->content->{html_url};

    # of course parameters to the method take precedence
    print $r->get( user => 'miyagawa', repo => 'Plack' )->content->{html_url};

    # it even works on other objects
    my $repo = Pithub::Repos->new( user => 'plu', repo => 'Pithub' );
    print $repo->watching->list->first->{login};

=attr auto_pagination

See also: L<Pithub::Result/auto_pagination>.

=cut

has 'auto_pagination' => (
    default => sub { 0 },
    is      => 'rw',
);

=attr api_uri

Defaults to L<https://api.github.com>.

Examples:

    my $users = Pithub::Users->new( api_uri => 'https://api-foo.github.com' );

    # ... is the same as ...

    my $users = Pithub::Users->new;
    $users->api_uri('https://api-foo.github.com');

=cut

has 'api_uri' => (
    default => sub { URI->new('https://api.github.com') },
    is      => 'rw',
    trigger => sub {
        my ( $self, $uri ) = @_;
        $self->{api_uri} = URI->new("$uri");
    },
);

=attr jsonp_callback

If you want to use the response directly in JavaScript for example,
Github supports setting a JSONP callback parameter.

See also: L<http://developer.github.com/v3/#json-p-callbacks>.

Examples:

    my $p = Pithub->new( jsonp_callback => 'loadGithubData' );
    my $result = $p->users->get( user => 'plu' );
    print $result->raw_content;

The result will look like this:

    loadGithubData({
        "meta": {
            "status": 200,
            "X-RateLimit-Limit": "5000",
            "X-RateLimit-Remaining": "4661"
        },
        "data": {
            "type": "User",
            "location": "Dubai",
            "url": "https://api.github.com/users/plu",
            "login": "plu",
            "name": "Johannes Plunien",
            ...
        }
    })

B<Be careful:> The L<content|Pithub::Result/content> method will
try to decode the JSON into a Perl data structure. This is not
possible if the C<< jsonp_callback >> is set:

    # calling this ...
    print $result->content;

    # ... will throw an exception like this ...
    Runtime error: malformed JSON string, neither array, object, number, string or atom,
    at character offset 0 (before "loadGithubData( ...

There are two helper methods:

=over

=item *

B<clear_jsonp_callback>: reset the jsonp_callback attribute

=item *

B<has_jsonp_callback>: check if the jsonp_callback attribute is set

=back

=cut

has 'jsonp_callback' => (
    clearer   => 'clear_jsonp_callback',
    is        => 'rw',
    predicate => 'has_jsonp_callback',
    required  => 0,
);

=attr per_page

By default undef, so it defaults to Github's default. See also:
L<http://developer.github.com/v3/#pagination>.

Examples:

    my $users = Pithub::Users->new( per_page => 100 );

    # ... is the same as ...

    my $users = Pithub::Users->new;
    $users->per_page(100);

There are two helper methods:

=over

=item *

B<clear_per_page>: reset the per_page attribute

=item *

B<has_per_page>: check if the per_page attribute is set

=back

=cut

has 'per_page' => (
    clearer   => 'clear_per_page',
    is        => 'rw',
    predicate => 'has_per_page',
    required  => 0,
);

=attr prepare_request

This is a CodeRef and can be used to modify the L<HTTP::Request>
object on a global basis, before it's being sent to the Github
API. It's useful for setting MIME types for example. See also:
L<http://developer.github.com/v3/mimes/>. This is the right way
to go if you want to modify the HTTP request of B<all> API
calls. If you just want to change a few, consider sending the
C<< prepare_request >> parameter on any method call.

Let's use this example from the Github docs:

B<Html>

C<< application/vnd.github-issue.html+json >>

Return html rendered from the body's markdown. Response will
include body_html.

Examples:

    my $p = Pithub::Issues->new(
        prepare_request => sub {
            my ($request) = @_;
            $request->header( Accept => 'application/vnd.github-issue.html+json' );
        }
    );

    my $result = $p->get(
        user     => 'miyagawa',
        repo     => 'Plack',
        issue_id => 209,
    );

    print $result->content->{body_html};

Please compare to the solution where you set the custom HTTP header
on the method call, instead globally on the object:

    my $p = Pithub::Issues->new;

    my $result = $p->get(
        user     => 'miyagawa',
        repo     => 'Plack',
        issue_id => 209,
        options  => {
            prepare_request => sub {
                my ($request) = @_;
                $request->header( Accept => 'application/vnd.github-issue.html+json' );
            },
        }
    );

    print $result->content->{body_html};

=cut

has 'prepare_request' => (
    clearer   => 'clear_prepare_request',
    is        => 'rw',
    predicate => 'has_prepare_request',
    required  => 0,
);

=attr repo

This can be set as a default repo to use for API calls that require
the repo parameter to be set. There are many of them and it can get
kind of verbose to include the repo and the user for all of the
calls, especially if you want to do many operations on the same
user/repo.

Examples:

    my $c = Pithub::Repos::Collaborators->new( repo => 'Pithub' );
    my $result = $c->list( user => 'plu' );

There are two helper methods:

=over

=item *

B<clear_repo>: reset the repo attribute

=item *

B<has_repo>: check if the repo attribute is set

=back

=cut

has 'repo' => (
    clearer   => 'clear_repo',
    is        => 'rw',
    predicate => 'has_repo',
    required  => 0,
);

=attr token

If the OAuth token is set, L<Pithub> will sent it via an HTTP header
on each API request. Currently the basic authentication method is
not supported.

See also: L<http://developer.github.com/v3/oauth/>

=cut

has 'token' => (
    clearer   => 'clear_token',
    is        => 'rw',
    predicate => '_has_token',
    required  => 0,
);

=attr ua

By default a L<LWP::UserAgent> object, but it can be anything that
implements the same interface.

=cut

has 'ua' => (
    builder => '_build_ua',
    is      => 'ro',
    lazy    => 1,
);

=attr user

This can be set as a default user to use for API calls that require
the user parameter to be set.

Examples:

    my $c = Pithub::Repos::Collaborators->new( user => 'plu' );
    my $result = $c->list( repo => 'Pithub' );

There are two helper methods:

=over

=item *

B<clear_user>: reset the user attribute

=item *

B<has_user>: check if the user attribute is set

=back

It might make sense to use this together with the repo attribute:

    my $c = Pithub::Repos::Commits->new( user => 'plu', repo => 'Pithub' );
    my $result = $c->list;
    my $result = $c->list_comments;
    my $result = $c->get('6b6127383666e8ecb41ec20a669e4f0552772363');

=cut

has 'user' => (
    clearer   => 'clear_user',
    is        => 'rw',
    predicate => 'has_user',
    required  => 0,
);

has '_json' => (
    builder => '_build__json',
    is      => 'ro',
    lazy    => 1,
);

my @TOKEN_REQUIRED = (
    'DELETE /user/emails',
    'GET /user',
    'GET /user/emails',
    'GET /user/followers',
    'GET /user/following',
    'GET /user/keys',
    'GET /user/repos',
    'PATCH /user',
    'POST /user/emails',
    'POST /user/keys',
    'POST /user/repos',
);

my @TOKEN_REQUIRED_REGEXP = (
    qr{^DELETE /gists/.*?$},
    qr{^DELETE /gists/comments/.*?$},
    qr{^DELETE /gists/[^/]+/star$},
    qr{^DELETE /orgs/[^/]+/members/.*?$},
    qr{^DELETE /orgs/[^/]+/public_members/.*?},
    qr{^DELETE /repos/[^/]+/[^/]+/collaborators/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/comments/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/downloads/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/hooks/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/issues/comments/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/issues/[^/]+/labels$},
    qr{^DELETE /repos/[^/]+/[^/]+/issues/[^/]+/labels/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/keys/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/labels/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/milestones/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/pulls/comments/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/releases/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/releases/assets/.*?$},
    qr{^DELETE /teams/.*?$},
    qr{^DELETE /teams/[^/]+/members/.*?$},
    qr{^DELETE /teams/[^/]+/repos/.*?$},
    qr{^DELETE /user/following/.*?$},
    qr{^DELETE /user/keys/.*?$},
    qr{^DELETE /user/starred/[^/]+/.*?$},
    qr{^DELETE /user/watched/[^/]+/.*?$},
    qr{^GET /gists/starred$},
    qr{^GET /gists/[^/]+/star$},
    qr{^GET /issues$},
    qr{^GET /orgs/[^/]+/members/.*?$},
    qr{^GET /orgs/[^/]+/teams$},
    qr{^GET /repos/[^/]+/[^/]+/collaborators$},
    qr{^GET /repos/[^/]+/[^/]+/collaborators/.*?$},
    qr{^GET /repos/[^/]+/[^/]+/hooks$},
    qr{^GET /repos/[^/]+/[^/]+/hooks/.*?$},
    qr{^GET /repos/[^/]+/[^/]+/keys$},
    qr{^GET /repos/[^/]+/[^/]+/keys/.*?$},
    qr{^GET /teams/.*?$},
    qr{^GET /teams/[^/]+/members$},
    qr{^GET /teams/[^/]+/members/.*?$},
    qr{^GET /teams/[^/]+/repos$},
    qr{^GET /teams/[^/]+/repos/.*?$},
    qr{^GET /user/following/.*?$},
    qr{^GET /user/keys/.*?$},
    qr{^GET /user/orgs$},
    qr{^GET /user/starred/[^/]+/.*?$},
    qr{^GET /user/watched$},
    qr{^GET /user/watched/[^/]+/.*?$},
    qr{^GET /users/[^/]+/events/orgs/.*?$},
    qr{^PATCH /gists/.*?$},
    qr{^PATCH /gists/comments/.*?$},
    qr{^PATCH /orgs/.*?$},
    qr{^PATCH /repos/[^/]+/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/comments/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/git/refs/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/hooks/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/issues/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/issues/comments/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/keys/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/labels/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/milestones/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/pulls/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/releases/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/pulls/comments/.*?$},
    qr{^PATCH /teams/.*?$},
    qr{^PATCH /user/keys/.*?$},
    qr{^PATCH /user/repos/.*?$},
    qr{^POST /repos/[^/]+/[^/]+/releases/[^/]+/assets.*?$},
    qr{^POST /gists/[^/]+/comments$},
    qr{^POST /orgs/[^/]+/repos$},
    qr{^POST /orgs/[^/]+/teams$},
    qr{^POST /repos/[^/]+/[^/]+/commits/[^/]+/comments$},
    qr{^POST /repos/[^/]+/[^/]+/downloads$},
    qr{^POST /repos/[^/]+/[^/]+/forks},
    qr{^POST /repos/[^/]+/[^/]+/git/blobs$},
    qr{^POST /repos/[^/]+/[^/]+/git/commits$},
    qr{^POST /repos/[^/]+/[^/]+/git/refs},
    qr{^POST /repos/[^/]+/[^/]+/git/tags$},
    qr{^POST /repos/[^/]+/[^/]+/git/trees$},
    qr{^POST /repos/[^/]+/[^/]+/hooks$},
    qr{^POST /repos/[^/]+/[^/]+/hooks/[^/]+/test$},
    qr{^POST /repos/[^/]+/[^/]+/issues$},
    qr{^POST /repos/[^/]+/[^/]+/issues/[^/]+/comments},
    qr{^POST /repos/[^/]+/[^/]+/issues/[^/]+/labels$},
    qr{^POST /repos/[^/]+/[^/]+/keys$},
    qr{^POST /repos/[^/]+/[^/]+/labels$},
    qr{^POST /repos/[^/]+/[^/]+/milestones$},
    qr{^POST /repos/[^/]+/[^/]+/pulls$},
    qr{^POST /repos/[^/]+/[^/]+/releases$},
    qr{^POST /repos/[^/]+/[^/]+/pulls/[^/]+/comments$},
    qr{^PUT /gists/[^/]+/star$},
    qr{^PUT /orgs/[^/]+/public_members/.*?$},
    qr{^PUT /repos/[^/]+/[^/]+/collaborators/.*?$},
    qr{^PUT /repos/[^/]+/[^/]+/issues/[^/]+/labels$},
    qr{^PUT /repos/[^/]+/[^/]+/pulls/[^/]+/merge$},
    qr{^PUT /teams/[^/]+/members/.*?$},
    qr{^PUT /teams/[^/]+/repos/.*?$},
    qr{^PUT /user/following/.*?$},
    qr{^PUT /user/starred/[^/]+/.*?$},
    qr{^PUT /user/watched/[^/]+/.*?$},
);

=method request

This method is the central point: All L<Pithub> are using this method
for making requests to the Github. If Github adds a new API call that
is not yet supported, this method can be used directly. It accepts
an hash with following keys:

=over

=item *

B<method>: mandatory string, one of the following:

=over

=item *

DELETE

=item *

GET

=item *

PATCH

=item *

POST

=item *

PUT

=back

=item *

B<path>: mandatory string of the relative path used for making the
API call.

=item *

B<data>: optional data reference, usually a reference to an array
or hash. It must be possible to serialize this using L<JSON>.
This will be the HTTP request body.

=item *

B<options>: optional hash reference to set additional options on
the request. So far C<< prepare_request >> is supported. See
more about that in the examples below. So this can be used on
B<every> method which maps directly to an API call.

=item *

B<params>: optional hash reference to set additional C<< GET >>
parameters. This could be achieved using the C<< prepare_request >>
in the C<< options >> hashref as well, but this is shorter. It's
being used in L<list method of Pithub::Issues|Pithub::Issues/list>
for example.

=back

Usually you should not end up using this method at all. It's only
available if L<Pithub> is missing anything from the Github v3 API.
Though here are some examples how to use it:

=over

=item *

Same as L<Pithub::Issues/list>:

    my $p      = Pithub->new;
    my $result = $p->request(
        method => 'GET',
        path   => '/repos/plu/Pithub/issues',
        params => {
            state     => 'closed',
            direction => 'asc',
        }
    );

=item *

Same as L<Pithub::Users/get>:

    my $p = Pithub->new;
    my $result = $p->request(
        method => 'GET',
        path   => '/users/plu',
    );

=item *

Same as L<Pithub::Gists/create>:

    my $p      = Pithub->new;
    my $method = 'POST';
    my $path   = '/gists';
    my $data   = {
        description => 'the description for this gist',
        public      => 1,
        files       => { 'file1.txt' => { content => 'String file content' } }
    };
    my $result = $p->request(
        method => $method,
        path   => $path,
        data   => $data,
    );

=item *

Same as L<Pithub::GitData::Trees/get>:

    my $p       = Pithub->new;
    my $method  = 'GET';
    my $path    = '/repos/miyagawa/Plack/issues/209';
    my $data    = undef;
    my $options = {
        prepare_request => sub {
            my ($request) = @_;
            $request->header( Accept => 'application/vnd.github-issue.html+json' );
        },
    };
    my $result = $p->request(
        method  => $method,
        path    => $path,
        data    => $data,
        options => $options,
    );

=back

This method always returns a L<Pithub::Result> object.

=cut

sub request {
    my ( $self, %args ) = @_;

    my $method  = delete $args{method} || croak 'Missing mandatory key in parameters: method';
    my $path    = delete $args{path}   || croak 'Missing mandatory key in parameters: path';
    my $data    = delete $args{data};
    my $options = delete $args{options};
    my $params  = delete $args{params};

    croak "Invalid method: $method" unless grep $_ eq $method, qw(DELETE GET PATCH POST PUT);

    my $uri = $self->_uri_for($path);

    if (my $host = delete $args{host}) {
        $uri->host($host);
    }

    if (my $query = delete $args{query}) {
        $uri->query_form(%$query);
    }

    my $request = $self->_request_for( $method, $uri, $data );

    if (my $headers = delete $args{headers}) {
        foreach my $header (keys %$headers) {
            $request->header($header, $headers->{$header});
        }
    }

    if ( $self->_token_required( $method, $path ) && !$self->has_token($request) ) {
        croak sprintf "Access token required for: %s %s (%s)", $method, $path, $uri;
    }

    if ($options) {
        croak 'The key options must be a hashref' unless ref $options eq 'HASH';
        croak 'The key prepare_request in the options hashref must be a coderef' if $options->{prepare_request} && ref $options->{prepare_request} ne 'CODE';

        if ( $options->{prepare_request} ) {
            $options->{prepare_request}->($request);
        }
    }

    if ($params) {
        croak 'The key params must be a hashref' unless ref $params eq 'HASH';
        my %query = ( $request->uri->query_form, %$params );
        $request->uri->query_form(%query);
    }

    my $response = $self->_make_request($request);

    return Pithub::Result->new(
        auto_pagination => $self->auto_pagination,
        response        => $response,
        _request        => sub { $self->request(@_) },
    );
}


sub _make_request {
    my($self, $request) = @_;

    if( my $cached_response = $self->shared_cache->get($request->uri) ) {
        # Add the If-None-Match header from the cache's ETag
        # and make the request
        $request->header( "If-None-Match" => $cached_response->header("ETag") );
        my $response = $self->ua->request($request);

        # Got 304 Not Modified, cache is still valid
        return $cached_response if ($response->code || 0) == 304;

        # The response changed, cache it and return it.
        $self->shared_cache->set( $request->uri, $response );
        return $response;
    }
    else {
        my $response = $self->ua->request($request);
        $self->shared_cache->set( $request->uri, $response );
        return $response;
    }
}


=method has_token (?$request)

This method checks if a token has been specified, or if not, and a request
object is passed, then it looks for an Authorization header in the request.

=cut

sub has_token {
    my ($self, $request) = @_;

    # If we have one specified in the object, return true
    return 1 if $self->_has_token;
    # If no reqest object here, we don't have a token
    return 0  unless $request;

    return 1 if $request->header('Authorization');
    return 0;
}

sub _build__json {
    my ($self) = @_;
    return JSON->new;
}

sub _build_ua {
    my ($self) = @_;
    return LWP::UserAgent->new;
}

sub _get_user_repo_args {
    my ( $self, $args ) = @_;
    $args->{user} = $self->user unless defined $args->{user};
    $args->{repo} = $self->repo unless defined $args->{repo};
    return $args;
}

sub _create_instance {
    my ( $self, $class ) = @_;
    my %args = (
        api_uri         => $self->api_uri,
        auto_pagination => $self->auto_pagination,
        ua              => $self->ua,
    );
    if ( $self->has_repo ) {
        $args{repo} = $self->repo;
    }
    if ( $self->has_token ) {
        $args{token} = $self->token;
    }
    if ( $self->has_user ) {
        $args{user} = $self->user;
    }
    if ( $self->has_per_page ) {
        $args{per_page} = $self->per_page;
    }
    if ( $self->has_jsonp_callback ) {
        $args{jsonp_callback} = $self->jsonp_callback;
    }
    if ( $self->has_prepare_request ) {
        $args{prepare_request} = $self->prepare_request;
    }
    return $class->new(%args);
}

sub _request_for {
    my ( $self, $method, $uri, $data ) = @_;

    my $headers = HTTP::Headers->new;

    if ( $self->has_token ) {
        $headers->header( 'Authorization' => sprintf( 'token %s', $self->token ) );
    }

    my $request = HTTP::Request->new( $method, $uri, $headers );

    if ($data) {
        $data = $self->_json->encode($data) if ref $data;
        $request->content($data);
    }

    $request->header( 'Content-Length' => length $request->content );

    if ( $self->has_prepare_request ) {
        $self->prepare_request->($request);
    }

    return $request;
}

sub _token_required {
    my ( $self, $method, $path ) = @_;
    return 1 if grep $_ eq "${method} ${path}", @TOKEN_REQUIRED;
    foreach my $regexp (@TOKEN_REQUIRED_REGEXP) {
        return 1 if "${method} ${path}" =~ /$regexp/;
    }
    return 0;
}

sub _uri_for {
    my ( $self, $path ) = @_;

    my $uri = $self->api_uri->clone;
    my $base_path = $uri->path;
    $path =~ s/^$base_path//;
    my @parts;
    push @parts, split qr{/+}, $uri->path;
    push @parts, split qr{/+}, $path;
    $uri->path( join '/',  grep { $_ } @parts );

    if ( $self->has_per_page ) {
        my %query = ( $uri->query_form, per_page => $self->per_page );
        $uri->query_form(%query);
    }

    if ( $self->has_jsonp_callback ) {
        my %query = ( $uri->query_form, callback => $self->jsonp_callback );
        $uri->query_form(%query);
    }

    return $uri;
}

sub _validate_user_repo_args {
    my ( $self, $args ) = @_;
    $args = $self->_get_user_repo_args($args);
    croak 'Missing key in parameters: user' unless $args->{user};
    croak 'Missing key in parameters: repo' unless $args->{repo};
}

1;
