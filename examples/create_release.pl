#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Pithub::Repos::Releases;

my $releases = Pithub::Repos::Releases->new(
    repo  => 'buhtip-repo',
    token => $ENV{GITHUB_TOKEN},
    user  => 'buhtip',
);

my $release = $releases->create(
    data => {
        name              => "v1.0.$$",
        tag_name          => "v1.0.$$",
        target_commitisih => 'master',
    }
);

my $asset = $releases->assets->create(
    release_id   => $release->content->{id},
    name         => 'Some Asset',
    data         => 'the asset data',
    content_type => 'text/plain',
);

$releases->assets->update(
    asset_id => $asset->content->{id},
    data     => {
        name  => 'Updated Name',
        label => 'Updated Label',
    }
);

warn Dumper $releases->get( release_id => $release->content->{id} )->content;
