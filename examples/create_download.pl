#!/usr/bin/env perl
use strict;
use warnings;
use Pithub::Repos::Downloads;

my $download = Pithub::Repos::Downloads->new(
    repo  => 'Pithub',
    token => 'my secret token',
    user  => 'plu',
);

my $result = $download->create(
    data => {
        name         => 'Pithub-0.01005-TRIAL.tar.gz',
        size         => ( stat('Pithub-0.01005-TRIAL.tar.gz') )[7],
        description  => 'Pithub v0.01005 TRIAL',
        content_type => 'application/x-gzip',
    },
);

if ( $result->success ) {
    my $upload = $download->upload(
        result => $result,
        file   => 'Pithub-0.01005-TRIAL.tar.gz',
    );
    if ( $upload->is_success ) {
        printf "The file has been uploaded succesfully and is now available at: %s\n", $result->content->{html_url};
    }
}

