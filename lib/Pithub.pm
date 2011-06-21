package Pithub;

# ABSTRACT: Github v3 API

use Moose;
use Class::MOP;
use namespace::autoclean;

=head1 NAME

Pithub

=head1 SYNOPSIS

    use Pithub;

    my $phub = Pithub->new(
        client_id     => 123,
        client_secret => 'secret',
    );

    # https://api.github.com/users/rjbs/followers
    my $result = $phub->users->followers( user => 'rjbs' );

    $result->auto_pagination(1);

    while ( my $row = $result->next ) {
        print $row->avatar_url;
        print $row->id;
        print $row->login;
        print $row->url;
    }

    # https://api.github.com/users/plu/repos
    my $result = $phub->repos->list( user => 'plu' );

    # https://api.github.com/repos/plu/Pithub
    my $result = $phub->repos->get( user => 'plu', repo => 'gearman-driver' );

    my $result = $phub->repos->edit( user => 'plu', repo => 'gearman-driver', data => { name => 'Gearman-Driver' });

    # https://api.github.com/repos/plu/gearman-driver/contributors
    my $result = $phub->repos->contributors( user => 'plu', 'repo' => 'gearman-driver' );

    # https://api.github.com/repos/plu/gearman-driver/languages
    my $result = $phub->repos->languages( user => 'plu', 'repo' => 'gearman-driver' );

    # https://api.github.com/repos/plu/gearman-driver/teams
    my $result = $phub->repos->teams( user => 'plu', 'repo' => 'gearman-driver' );

    # https://api.github.com/repos/plu/gearman-driver/tags
    my $result = $phub->repos->tags( user => 'plu', 'repo' => 'gearman-driver' );

    # https://api.github.com/repos/plu/gearman-driver/branches
    my $result = $phub->repos->branches( user => 'plu', 'repo' => 'gearman-driver' );


=cut

has 'gists' => (
    is         => 'ro',
    isa        => 'Pithub::API::Gists',
    lazy_build => 1,
);

has 'git_data' => (
    is         => 'ro',
    isa        => 'Pithub::API::GitData',
    lazy_build => 1,
);

has 'issues' => (
    is         => 'ro',
    isa        => 'Pithub::API::Issues',
    lazy_build => 1,
);

has 'orgs' => (
    is         => 'ro',
    isa        => 'Pithub::API::Orgs',
    lazy_build => 1,
);

has 'pull_requests' => (
    is         => 'ro',
    isa        => 'Pithub::API::PullRequests',
    lazy_build => 1,
);

has 'repos' => (
    is         => 'ro',
    isa        => 'Pithub::API::Repos',
    lazy_build => 1,
);

has 'users' => (
    is         => 'ro',
    isa        => 'Pithub::API::Users',
    lazy_build => 1,
);

sub _build_gists {
    return shift->_build('Pithub::API::Gists');
}

sub _build_git_data {
    return shift->_build('Pithub::API::GitData');
}

sub _build_issues {
    return shift->_build('Pithub::API::Issues');
}

sub _build_orgs {
    return shift->_build('Pithub::API::Orgs');
}

sub _build_pull_requests {
    return shift->_build('Pithub::API::PullRequests');
}

sub _build_repos {
    return shift->_build('Pithub::API::Repos');
}

sub _build_users {
    return shift->_build('Pithub::API::Users');
}

sub _build {
    my ( $self, $class ) = @_;
    Class::MOP::load_class($class);
    return $class->new;
}

__PACKAGE__->meta->make_immutable;

1;
