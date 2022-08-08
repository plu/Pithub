#!perl

use strict;
use warnings;

use Test::Differences qw( eq_or_diff );
use Test::Exception;    # throws_ok
use Test::More import => [qw( done_testing is isa_ok )];

use lib 't/lib';
use Pithub::Search        ();
use Pithub::Test::Factory ();

# Pithub::Search->email
{
    my $obj = Pithub::Test::Factory->create('Pithub::Search');

    isa_ok $obj, 'Pithub::Search';

    throws_ok { $obj->email } qr{Missing key in parameters: email}, 'Missing email parameter';

    {
        my $result = $obj->email( email => 'bla' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/legacy/user/email/bla', 'HTTP path';
    }
}

# Pithub::Search->issues
{
    my $obj = Pithub::Test::Factory->create( 'Pithub::Search', user => 'foo', repo => 'bar' );

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

# Pithub::Search->repos
{
    my $obj = Pithub::Test::Factory->create('Pithub::Search');

    isa_ok $obj, 'Pithub::Search';

    throws_ok { $obj->repos } qr{Missing key in parameters: keyword}, 'Missing keyword parameter';

    {
        my $result = $obj->repos( keyword => 'bla', params => { language => 'Perl', start_page => '100' } );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/legacy/repos/search/bla', 'HTTP path';
        eq_or_diff { $result->request->uri->query_form }, { language => 'Perl', start_page => '100', per_page => 100 }, 'Query params';
    }
}

# Pithub::Search->users
{
    my $obj = Pithub::Test::Factory->create('Pithub::Search');

    isa_ok $obj, 'Pithub::Search';

    throws_ok { $obj->users } qr{Missing key in parameters: keyword}, 'Missing keyword parameter';

    {
        my $result = $obj->users( keyword => 'bla' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/legacy/user/search/bla', 'HTTP path';
    }
}

done_testing;
