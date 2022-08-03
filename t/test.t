#!perl

use strict;
use warnings;

use lib 't/lib';
use Pithub::Test qw( uri_is );

subtest 'Test::Most imported' => sub {
    pass('Loaded test functions');
    cmp_deeply {}, {}, 'Test::Deep imported';
};

subtest 'uri_is' => sub {
    uri_is 'http://example.com', 'http://example.com', 'same URI';
    uri_is 'http://example.com?foo=bar&up=down',
           'http://example.com?up=down&foo=bar', 'same query, different order';
};

done_testing;
