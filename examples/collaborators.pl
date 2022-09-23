#!/usr/bin/perl env

=head1 SYNOPSIS

    LWPCL_REDACT_HEADERS=Authorization perl examples/collaborators.pl

=head1 DESCRIPTION

List all of the collaborators for a repository.  Also, display user agent
debugging information.

=cut

use strict;
use warnings;
use feature qw( say );

use Git::Raw::Config                  ();
use LWP::ConsoleLogger::Easy 0.000029 qw( debug_ua );
use LWP::UserAgent                    ();
use Pithub::Repos::Collaborators      ();

# WWW::Mechanize accepts gzip by default but then doesn't actually decode it
# for you. See https://github.com/kentnl/HTTP-Tiny-Mech/pull/2 for a detailed
# discussion.

my $ua = LWP::UserAgent->new;
debug_ua($ua);

my $c = Pithub::Repos::Collaborators->new(
    token => get_token(),
    ua    => $ua,
);

my $result = $c->list(
    repo => 'test-www-mechanize-psgi',
    user => 'acme',
);

while ( my $next = $result->next ) {
    say $next->{login};
}

# This script requires a GitHub access token.  You may either use the
# GITHUB_TOKEN environment variable or set "github.token" in your Git config.

sub get_token {
    return $ENV{GITHUB_TOKEN} if $ENV{GITHUB_TOKEN};

    my $config = Git::Raw::Config->default;
    return $config->str('github.token');
}
