use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users');
}

my $obj = Pithub::Test->create('Pithub::Users');

isa_ok $obj, 'Pithub::Users';

throws_ok { $obj->get } qr{Access token required for: GET /user }, 'Token required';

{
    my $result = $obj->get( user => 'plu' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/users/plu', 'HTTP path';

    ok $result->response->parse_response( Pithub::Test->get_response('users.get.noauth') ), 'Load response' if $obj->skip_request;

    is $result->code,    200, 'HTTP status';
    is $result->success, 1,   'Successful';

    is $result->content->{bio},          undef,                              'Attribute exists: bio';
    is $result->content->{blog},         '',                                 'Attribute exists: blog';
    is $result->content->{company},      '',                                 'Attribute exists: company';
    is $result->content->{created_at},   '2008-10-29T09:03:04Z',             'Attribute exists: created_at';
    is $result->content->{email},        'plu@pqpq.de',                      'Attribute exists: email';
    is $result->content->{followers},    54,                                 'Attribute exists: followers';
    is $result->content->{following},    178,                                'Attribute exists: following';
    is $result->content->{html_url},     'https://github.com/plu',           'Attribute exists: html_url';
    is $result->content->{id},           31597,                              'Attribute exists: id';
    is $result->content->{location},     'Dubai',                            'Attribute exists: location';
    is $result->content->{login},        'plu',                              'Attribute exists: login';
    is $result->content->{name},         'Johannes Plunien',                 'Attribute exists: name';
    is $result->content->{public_gists}, 38,                                 'Attribute exists: public_gists';
    is $result->content->{public_repos}, 17,                                 'Attribute exists: public_repos';
    is $result->content->{type},         'User',                             'Attribute exists: type';
    is $result->content->{url},          'https://api.github.com/users/plu', 'Attribute exists: url';
}

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->get;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user', 'HTTP path';
}

done_testing;
