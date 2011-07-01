package Pithub::Base;

# ABSTRACT: Github v3 base class for all Pithub modules

use Moose;
use Carp qw(croak);
use LWP::UserAgent;
use MooseX::Types::URI qw(Uri);
use Pithub::Request;
use Pithub::Response;
use Pithub::Result;
use namespace::autoclean;

=head1 DESCRIPTION

All L<Pithub/MODULES> inherit from L<Pithub::Base>, even L<Pithub>
itself. So all attributes listed here can either be set in the
constructor or via the setter on the objects.

=attr auto_pagination

See also: L<Pithub::Result/auto_pagination>.

=cut

has 'auto_pagination' => (
    default => 0,
    is      => 'rw',
    isa     => 'Bool',
);

=attr api_uri

Defaults to L<https://api.github.com>.

Examples:

    $users = Pithub::Users->new( api_uri => 'https://api-foo.github.com' );

    $users = Pithub::Users->new;
    $users->api_uri('https://api-foo.github.com');

=cut

has 'api_uri' => (
    coerce   => 1,
    default  => 'https://api.github.com',
    is       => 'rw',
    isa      => Uri,
    required => 1,
);

=attr jsonp_callback

If you want to use the response directly in JavaScript for example,
Github supports setting a JSONP callback parameter.

See also: L<http://developer.github.com/v3/#json-p-callbacks>.

Examples:

    $p = Pithub->new( jsonp_callback => 'loadGithubData' );
    $result = $p->users->get( user => 'plu' );
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
    isa       => 'Str',
    predicate => 'has_jsonp_callback',
    required  => 0,
);

=attr per_page

By default undef, so it defaults to Github's default. See also:
L<http://developer.github.com/v3/#pagination>.

Examples:

    $users = Pithub::Users->new( per_page => 100 );

    $users = Pithub::Users->new;
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
    isa       => 'Int',
    predicate => 'has_per_page',
    required  => 0,
);

=attr repo

This can be set as a default repo to use for API calls that require
the repo parameter to be set.

Examples:

    $c = Pithub::Repos::Collaborators->new( repo => 'Pithub' );
    $result = $c->list( user => 'plu' );

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
    isa       => 'Str',
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
    isa       => 'Str',
    predicate => 'has_token',
    required  => 0,
);

=attr ua

By default a L<LWP::UserAgent> object, but it can be anything that
implements the same interface.

=cut

has 'ua' => (
    is         => 'ro',
    isa        => 'Object',
    lazy_build => 1,
);

=attr user

This can be set as a default user to use for API calls that require
the user parameter to be set.

Examples:

    $c = Pithub::Repos::Collaborators->new( user => 'plu' );
    $result = $c->list( repo => 'Pithub' );

There are two helper methods:

=over

=item *

B<clear_user>: reset the user attribute

=item *

B<has_user>: check if the user attribute is set

=back

It might makes sense to use this together with the repo attribute:

    $c = Pithub::Repos::Commits->new( user => 'plu', repo => 'Pithub' );
    $result = $c->list;
    $result = $c->list_comments;
    $reuslt = $c->get('6b6127383666e8ecb41ec20a669e4f0552772363');

=cut

has 'user' => (
    clearer   => 'clear_user',
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_user',
    required  => 0,
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
    qr{^DELETE /repos/[^/]+/[^/]+/issues/comments/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/issues/[^/]+/labels$},
    qr{^DELETE /repos/[^/]+/[^/]+/issues/[^/]+/labels/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/keys/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/labels/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/milestones/.*?$},
    qr{^DELETE /repos/[^/]+/[^/]+/pulls/comments/.*?$},
    qr{^DELETE /teams/.*?$},
    qr{^DELETE /teams/[^/]+/members/.*?$},
    qr{^DELETE /teams/[^/]+/repos/.*?$},
    qr{^DELETE /user/following/.*?$},
    qr{^DELETE /user/keys/.*?$},
    qr{^DELETE /user/watched/[^/]+/.*?$},
    qr{^GET /gists/starred$},
    qr{^GET /gists/[^/]+/star$},
    qr{^GET /orgs/[^/]+/members/.*?$},
    qr{^GET /orgs/[^/]+/teams$},
    qr{^GET /repos/[^/]+/[^/]+/collaborators$},
    qr{^GET /repos/[^/]+/[^/]+/collaborators/.*?$},
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
    qr{^GET /user/watched$},
    qr{^GET /user/watched/[^/]+/.*?$},
    qr{^PATCH /gists/.*?$},
    qr{^PATCH /gists/comments/.*?$},
    qr{^PATCH /orgs/.*?$},
    qr{^PATCH /repos/[^/]+/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/comments/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/git/refs/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/issues/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/issues/comments/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/keys/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/labels/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/milestones/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/pulls/.*?$},
    qr{^PATCH /repos/[^/]+/[^/]+/pulls/comments/.*?$},
    qr{^PATCH /teams/.*?$},
    qr{^PATCH /user/keys/.*?$},
    qr{^PATCH /user/repos/.*?$},
    qr{^POST /gists/[^/]+/comments$},
    qr{^POST /orgs/[^/]+/repos$},
    qr{^POST /orgs/[^/]+/teams$},
    qr{^POST /repos/[^/]+/[^/]+/commits/[^/]+/comments$},
    qr{^POST /repos/[^/]+/[^/]+/forks},
    qr{^POST /repos/[^/]+/[^/]+/git/blobs$},
    qr{^POST /repos/[^/]+/[^/]+/git/commits$},
    qr{^POST /repos/[^/]+/[^/]+/git/refs},
    qr{^POST /repos/[^/]+/[^/]+/git/tags$},
    qr{^POST /repos/[^/]+/[^/]+/git/trees$},
    qr{^POST /repos/[^/]+/[^/]+/issues$},
    qr{^POST /repos/[^/]+/[^/]+/issues/[^/]+/comments},
    qr{^POST /repos/[^/]+/[^/]+/issues/[^/]+/labels$},
    qr{^POST /repos/[^/]+/[^/]+/keys$},
    qr{^POST /repos/[^/]+/[^/]+/labels$},
    qr{^POST /repos/[^/]+/[^/]+/milestones$},
    qr{^POST /repos/[^/]+/[^/]+/pulls$},
    qr{^POST /repos/[^/]+/[^/]+/pulls/[^/]+/comments$},
    qr{^PUT /gists/[^/]+/star$},
    qr{^PUT /orgs/[^/]+/public_members/.*?$},
    qr{^PUT /repos/[^/]+/[^/]+/collaborators/.*?$},
    qr{^PUT /repos/[^/]+/[^/]+/issues/[^/]+/labels$},
    qr{^PUT /repos/[^/]+/[^/]+/pulls/[^/]+/merge$},
    qr{^PUT /teams/[^/]+/members/.*?$},
    qr{^PUT /teams/[^/]+/repos/.*?$},
    qr{^PUT /user/following/.*?$},
    qr{^PUT /user/watched/[^/]+/.*?$},
);

=method request

This method is the central point: All L<Pithub> are using this method
for making requests to the Github. If Github adds a new API call that
is not yet supported, this method can be used directly. It accepts
following parameters:

=over

=item *

B<$method>: mandatory string, one of the following:

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

B<$path>: mandatory string of the relative path used for making the
API call.

=item *

B<$data>: optional data reference, usually a reference to an array
or hash. It must be possible to serialize this using L<JSON::Any>.
This will be the HTTP request body.

=item *

B<$options>: optional hash reference to set additional options on
the request. So far only C<< prepare_uri >> is supported. See more
about that in the examples below.

=back

Usually you should not end up using this method at all. It's only
available if L<Pithub> is missing anything from the Github v3 API.
Though here are some examples how to use it:

=item *

Same as L<Pithub::Users/get>:

    $p = Pithub->new;
    $result = $p->request( GET => '/users/plu' );

Same as L<Pithub::Gists/create>:

    $p      = Pithub->new;
    $method = 'POST';
    $path   = '/gists';
    $data   = {
        description => 'the description for this gist',
        public      => 1,
        files       => { 'file1.txt' => { content => 'String file content' } }
    };
    $result = $p->request( $method, $path, $data );

Same as L<Pithub::GitData::Trees/get>:

    $p       = Pithub->new;
    $method  = 'GET';
    $path    = '/repos/plu/Pithub/git/trees/aac667c5aaa6e49572894e8c722d0705bb00fab2';
    $data    = undef;
    $options = {
        prepare_uri => sub {
            my ($uri) = @_;
            my %query = ( $uri->query_form, recursive => 1 );
            $uri->query_form(%query);
        },
    };
    $result = $p->request( $method, $path, $data, $options );

Always be careful using C<< prepare_uri >> and C<< query_form >>. If
the option L</per_page> is set, you might override the pagination
parameter. That's the reason for this construct:

    my %query = ( $uri->query_form, recursive => 1 );
    $uri->query_form(%query);

This method always returns a L<Pithub::Result> object.

=cut

sub request {
    my $self = shift;

    my %req_args = $self->_prepare_request_args(@_);
    my $request  = Pithub::Request->new(%req_args);
    my %res_args = $self->_prepare_response_args($request);
    my $response = Pithub::Response->new(%res_args);

    return Pithub::Result->new(
        auto_pagination => $self->auto_pagination,
        response        => $response,
        _request        => sub { $self->request(@_) },
    );
}

sub _build_ua {
    my ($self) = @_;
    return LWP::UserAgent->new;
}

sub _merge_args {
    my ( $orig, $self ) = @_;
    my @args = $self->$orig;
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
    return ( %args, @args );
}

sub _prepare_request_args {
    my ( $self, $method, $path, $data, $options ) = @_;

    croak 'Missing mandatory parameters: $method, $path' if scalar @_ < 3;
    croak "Invalid method: ${method}" unless grep $_ eq $method, qw(DELETE GET PATCH POST PUT);

    my $uri = $self->api_uri->clone;
    $uri->path($path);

    if ( $self->has_per_page ) {
        my %query = ( $uri->query_form, per_page => $self->per_page );
        $uri->query_form(%query);
    }

    if ( $self->has_jsonp_callback ) {
        my %query = ( $uri->query_form, callback => $self->jsonp_callback );
        $uri->query_form(%query);
    }

    if ($options) {
        croak 'The parameter $options must be a hashref' unless ref $options eq 'HASH';
        croak 'The key prepare_uri in the $options hashref must be a coderef' if $options->{prepare_uri} && ref $options->{prepare_uri} ne 'CODE';
        $options->{prepare_uri}->($uri) if $options->{prepare_uri};
    }

    if ( $self->_token_required( $method, $path ) && !$self->has_token ) {
        croak sprintf "Access token required for: %s %s (%s)", $method, $path, $uri;
    }

    my %args = (
        uri    => $uri,
        method => $method,
        ua     => $self->ua,
    );

    $args{data}  = $data        if defined $data;
    $args{token} = $self->token if $self->has_token;

    return %args;
}

sub _prepare_response_args {
    my ( $self, $request ) = @_;
    my %args = ( request => $request );
    $args{http_response} = $request->send;
    return %args;
}

sub _token_required {
    my ( $self, $method, $path ) = @_;
    return 1 if grep $_ eq "${method} ${path}", @TOKEN_REQUIRED;
    foreach my $regexp (@TOKEN_REQUIRED_REGEXP) {
        return 1 if "${method} ${path}" =~ /$regexp/;
    }
    return 0;
}

sub _validate_user_repo_args {
    my ( $self, $args ) = @_;
    $args->{user} = $self->user unless defined $args->{user};
    $args->{repo} = $self->repo unless defined $args->{repo};
    croak 'Missing key in parameters: user' unless $args->{user};
    croak 'Missing key in parameters: repo' unless $args->{repo};
}

__PACKAGE__->meta->make_immutable;

1;
