package Pithub;

# ABSTRACT: Github v3 API

use Moose;
use Class::MOP;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Gists' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::GitData' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Issues' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Orgs' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::PullRequests' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Repos' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Users' };

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

__PACKAGE__->meta->make_immutable;

1;
