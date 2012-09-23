use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Search');
}

# Pithub::Search->issues
{
    my $obj = Pithub::Test->create( 'Pithub::Search', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Search';

    throws_ok { $obj->issues } qr{Missing key in parameters: state}, 'Missing state parameter';
    throws_ok { $obj->issues( state => 'open' ) } qr{Missing key in parameters: keyword}, 'Missing keyword parameter';

    {
        my $result = $obj->issues(
            state   => 'open',
            keyword => 'term',
        );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/legacy/issues/search/foo/bar/open/term', 'HTTP path';
    }
}

done_testing;
