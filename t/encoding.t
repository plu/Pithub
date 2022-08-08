#!/usr/bin/env perl

use strict;
use warnings;

use JSON::MaybeXS     qw( JSON );
use Pithub            ();
use Pithub::Users     ();
use Test::Differences qw( eq_or_diff );
use Test::More import => [qw( done_testing is isa_ok like ok )];

use lib 't/lib';
use Pithub::Test::Factory ();

{
    my $obj = Pithub::Test::Factory->create('Pithub::Users');
    ok $obj->utf8, 'enabled en/decoding json';
    $obj->ua->add_response('users/rwstauner.GET');

    isa_ok $obj, 'Pithub::Users';

    {
        my $result = $obj->get( user => 'rwstauner' );
        ok $result->utf8, 'enabled en/decoding json';

        my $string = $result->content->{bio};
        is $string, "\x{26F0}", 'Attribute exists';
        ok utf8::is_utf8($string), 'field is a character string';

        utf8::encode($string);
        ok !utf8::is_utf8($string), 'encoded to a byte string';
        is $string, "\xe2\x9b\xb0", 'string encodes to utf-8';
    }
}

{
    my $json = JSON->new->utf8;
    my $p    = Pithub::Test::Factory->create('Pithub');
    ok $p->utf8, 'enabled en/decoding json';
    $p->token('123');
    my $request = $p->request( method => 'POST', path => '/foo', data => { some => "bullet \x{2022}" } )->request;
    like $request->content, qr/bullet \xe2\x80\xa2/, 'character string utf-8 encoded in request';
    eq_or_diff $json->decode( $request->content ), { some => "bullet \x{2022}" }, 'character strings preserved in json round-trip';
}

{
    my $obj = Pithub::Test::Factory->create('Pithub::Users', utf8 => 0); # disable en/decoding
    ok !$obj->utf8, 'disabled en/decoding json';
    $obj->ua->add_response('users/rwstauner.GET');

    isa_ok $obj, 'Pithub::Users';

    {
        my $result = $obj->get( user => 'rwstauner' );
        ok !$result->utf8, 'disabled en/decoding json';

        my $string = $result->content->{bio};
        is $string, "\xe2\x9b\xb0", 'Attribute exists';
        ok utf8::is_utf8($string), 'field is a character string';

        utf8::decode($string);
        ok utf8::is_utf8($string), 'decoded to a wide character';
        is $string, "\x{26F0}", 'string decodes to a wide character';
    }
}

{
    my $json = JSON->new;
    my $p    = Pithub::Test::Factory->create('Pithub', utf8 => 0); # disable en/decoding
    ok !$p->utf8, 'disabled en/decoding json';
    $p->token('123');
    my $request = $p->request( method => 'POST', path => '/foo', data => { some => "bullet \xe2\x80\xa2" } )->request;
    like $request->content, qr/bullet \xe2\x80\xa2/, 'character string utf-8 encoded in request';
    eq_or_diff $json->decode( $request->content ), { some => "bullet \xe2\x80\xa2" }, 'character strings preserved in json round-trip';
}

done_testing;
