use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

SKIP: {
    skip 'Set PITHUB_TEST_LIVE to true to run this test', 4 unless $ENV{PITHUB_TEST_LIVE};

    my $base = Pithub->new;
    my $result = $base->request( GET => '/' );

    is $result->code,        200,  'HTTP status is 200';
    is $result->success,     1,    'Successful';
    is $result->raw_content, '{}', 'Empty JSON object';
    eq_or_diff $result->content, {}, 'Empty hashref';
}

done_testing;
