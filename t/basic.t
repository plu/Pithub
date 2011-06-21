use Test::Most;

BEGIN {
    use_ok('Pithub');
}

my $phub = Pithub->new;

isa_ok $phub, 'Pithub';

my %accessors = (
    gists => {
        isa       => 'Pithub::Gists',
        accessors => { comments => 'Pithub::Gists::Comments' }
    },
    git_data => {
        isa       => 'Pithub::GitData',
        accessors => {
            blobs      => 'Pithub::GitData::Blobs',
            commits    => 'Pithub::GitData::Commits',
            references => 'Pithub::GitData::References',
            tags       => 'Pithub::GitData::Tags',
            trees      => 'Pithub::GitData::Trees',
        }
    },
    issues => {
        isa       => 'Pithub::Issues',
        accessors => {
            comments   => 'Pithub::Issues::Comments',
            events     => 'Pithub::Issues::Events',
            labels     => 'Pithub::Issues::Labels',
            milestones => 'Pithub::Issues::Milestones',
        }
    },
    orgs => {
        isa       => 'Pithub::Orgs',
        accessors => {
            members => 'Pithub::Orgs::Members',
            teams   => 'Pithub::Orgs::Teams',
        }
    },
    pull_requests => {
        isa       => 'Pithub::PullRequests',
        accessors => { comments => 'Pithub::PullRequests::Comments' }
    },
    repos => {
        isa       => 'Pithub::Repos',
        accessors => {
            collaborators => 'Pithub::Repos::Collaborators',
            commits       => 'Pithub::Repos::Commits',
            downloads     => 'Pithub::Repos::Downloads',
            forks         => 'Pithub::Repos::Forks',
            keys          => 'Pithub::Repos::Keys',
            watching      => 'Pithub::Repos::Watching',
        }
    },
    users => {
        isa       => 'Pithub::Users',
        accessors => {
            emails    => 'Pithub::Users::Emails',
            followers => 'Pithub::Users::Followers',
            keys      => 'Pithub::Users::Keys',
        }
    },
);

while ( my ( $main_accessor, $sub ) = each %accessors ) {
    isa_ok $phub->$main_accessor, $sub->{isa};
    while ( my ( $sub_accessor, $isa ) = each %{ $sub->{accessors} } ) {
        isa_ok $phub->$main_accessor->$sub_accessor, $isa;
    }
}

done_testing;
