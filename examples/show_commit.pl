#!/usr/bin/env perl
use strict;
use warnings;
use Pithub::Repos::Commits;

# https://github.com/kraih/mojo/commit/ad0b3b3fcaacffe39fea34b126cd927e3f02ec78
my $url = $ARGV[0] || die "usage: show_commit.pl <url>\n";

my ($user, $repo, $sha) = $url =~ qr{https?://github.com/([^/]+)/([^/]+)/commit/([^/]+)};

my $commit = Pithub::Repos::Commits->new->get(
    user => $user,
    repo => $repo,
    sha => $sha,
);

unless ($commit->success) {
    die "could not fetch the commit from Github: $url\n";
}

my $c = $commit->content;

print <<EOF;
commit $c->{sha}
Author: $c->{commit}{author}{name} <$c->{commit}{author}{email}>
Date:   $c->{commit}{author}{date}

    $c->{commit}{message}

EOF

foreach my $f (@{ $c->{files} }) {
    print <<EOF;
diff --git a/$f->{filename} b/$f->{filename}
$f->{patch}
EOF
}
