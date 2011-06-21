use Test::Most;

BEGIN {
    use_ok('Pithub');
    use_ok('Pithub::API::Gists');
    use_ok('Pithub::API::Gists::Comments');
    use_ok('Pithub::API::GitData');
    use_ok('Pithub::API::GitData::Blobs');
    use_ok('Pithub::API::GitData::Commits');
    use_ok('Pithub::API::GitData::References');
    use_ok('Pithub::API::GitData::Tags');
    use_ok('Pithub::API::GitData::Trees');
    use_ok('Pithub::API::Issues');
    use_ok('Pithub::API::Issues::Comments');
    use_ok('Pithub::API::Issues::Events');
    use_ok('Pithub::API::Issues::Labels');
    use_ok('Pithub::API::Issues::Milestones');
    use_ok('Pithub::API::Orgs');
    use_ok('Pithub::API::Orgs::Members');
    use_ok('Pithub::API::Orgs::Teams');
    use_ok('Pithub::API::PullRequests');
    use_ok('Pithub::API::PullRequests::Comments');
    use_ok('Pithub::API::Repos');
    use_ok('Pithub::API::Repos::Collaborators');
    use_ok('Pithub::API::Repos::Commits');
    use_ok('Pithub::API::Repos::Downloads');
    use_ok('Pithub::API::Repos::Forks');
    use_ok('Pithub::API::Repos::Keys');
    use_ok('Pithub::API::Repos::Watching');
    use_ok('Pithub::API::Users');
    use_ok('Pithub::API::Users::Emails');
    use_ok('Pithub::API::Users::Followers');
    use_ok('Pithub::API::Users::Keys');
    use_ok('Pithub::Result');
}

my $phub = Pithub->new;

isa_ok $phub, 'Pithub';

my %accessors = (
    gists => {
        isa       => 'Pithub::API::Gists',
        accessors => { comments => 'Pithub::API::Gists::Comments' }
    },
    git_data => {
        isa       => 'Pithub::API::GitData',
        accessors => {
            blobs      => 'Pithub::API::GitData::Blobs',
            commits    => 'Pithub::API::GitData::Commits',
            references => 'Pithub::API::GitData::References',
            tags       => 'Pithub::API::GitData::Tags',
            trees      => 'Pithub::API::GitData::Trees',
        }
    },
    issues => {
        isa       => 'Pithub::API::Issues',
        accessors => {
            comments   => 'Pithub::API::Issues::Comments',
            events     => 'Pithub::API::Issues::Events',
            labels     => 'Pithub::API::Issues::Labels',
            milestones => 'Pithub::API::Issues::Milestones',
        }
    },
    orgs => {
        isa       => 'Pithub::API::Orgs',
        accessors => {
            members => 'Pithub::API::Orgs::Members',
            teams   => 'Pithub::API::Orgs::Teams',
        }
    },
    pull_requests => {
        isa       => 'Pithub::API::PullRequests',
        accessors => { comments => 'Pithub::API::PullRequests::Comments' }
    },
    repos => {
        isa       => 'Pithub::API::Repos',
        accessors => {
            collaborators => 'Pithub::API::Repos::Collaborators',
            commits       => 'Pithub::API::Repos::Commits',
            downloads     => 'Pithub::API::Repos::Downloads',
            forks         => 'Pithub::API::Repos::Forks',
            keys          => 'Pithub::API::Repos::Keys',
            watching      => 'Pithub::API::Repos::Watching',
        }
    },
    users => {
        isa       => 'Pithub::API::Users',
        accessors => {
            emails    => 'Pithub::API::Users::Emails',
            followers => 'Pithub::API::Users::Followers',
            keys      => 'Pithub::API::Users::Keys',
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
