use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs');
}

my $obj = Pithub::Test->create( 'Pithub::Orgs', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Orgs';

throws_ok { $obj->update } qr{Missing key in parameters: org}, 'No parameters';
throws_ok { $obj->update( org => 'bla' ) } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->update( org => 'bla', data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->update( org => 'bla', data => { foo => 123 } ); } qr{Access token required for: PATCH /orgs/bla}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update(
        org  => 'some-org',
        data => {
            billing_email => 'support@github.com',
            blog          => 'https://github.com/blog',
            company       => 'GitHub',
            email         => 'support@github.com',
            location      => 'San Francisco',
            name          => 'github',
        }
    );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/orgs/some-org', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content,
      '{"email":"support@github.com","location":"San Francisco","billing_email":"support@github.com","name":"github","blog":"https://github.com/blog","company":"GitHub"}',
      'HTTP body';
}

done_testing;
