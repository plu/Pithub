use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs::Teams');
}

my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

isa_ok $obj, 'Pithub::Orgs::Teams';

throws_ok { $obj->create } qr{Missing key in parameters: org}, 'No parameters';
throws_ok { $obj->create( org => 'blorg', data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
throws_ok { $obj->create( org => 'blorg', data => { foo => 1 } ); } qr{Access token required for: POST /orgs/blorg/teams\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create(
        org  => 'blorg',
        data => {
            name       => 'new team',
            permission => 'push',
            repo_names => ['github/dotfiles']
        }
    );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/orgs/blorg/teams', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"permission":"push","name":"new team","repo_names":["github/dotfiles"]}', 'HTTP body';
}

done_testing;
