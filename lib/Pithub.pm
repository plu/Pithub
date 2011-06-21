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

    my $result = $phub->users->followers({ user => 'rjbs' });

    $result->auto_pagination(1);

    while ( my $row = $result->next ) {
        print $row->avatar_url;
        print $row->id;
        print $row->login;
        print $row->url;
    }

    my $result = $phub->gists->comments->create({ gist_id => 1, data => { body => 'some comment' } });
    my $result = $phub->gists->comments->delete({ comment_id => 1 });
    my $result = $phub->gists->comments->get({ comment_id => 1 });
    my $result = $phub->gists->comments->list({ gist_id => 1 });
    my $result = $phub->gists->comments->update({ comment_id => 1, data => { body => 'some comment' } });
    my $result = $phub->gists->create({ data => { description => 'foo bar' } });
    my $result = $phub->gists->delete({ gist_id => 784612 });
    my $result = $phub->gists->fork({ gist_id => 784612 });
    my $result = $phub->gists->get({ gist_id => 784612 });
    my $result = $phub->gists->is_starred({ gist_id => 784612 });
    my $result = $phub->gists->list({ user => 'plu' });
    my $result = $phub->gists->star({ gist_id => 784612 });
    my $result = $phub->gists->unstar({ gist_id => 784612 });
    my $result = $phub->gists->update({ gist_id => 784612, data => { description => 'bar foo' } });
    my $result = $phub->git_data->blobs->create({ user => 'plu', repo => 'Pithub', data => { content => 'some blob' } });
    my $result = $phub->git_data->blobs->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });
    my $result = $phub->git_data->commits->create({ user => 'plu', repo => 'Pithub', data => { message => 'some message' } });
    my $result = $phub->git_data->commits->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });
    my $result = $phub->git_data->references->create({ user => 'plu', repo => 'Pithub', { data => { ref => 'tags/v1.0', sha => 'df21b2660fb6' } } });
    my $result = $phub->git_data->references->get({ user => 'plu', repo => 'Pithub', ref => 'heads/master' });
    my $result = $phub->git_data->references->list({ user => 'plu', repo => 'Pithub' });
    my $result = $phub->git_data->references->list({ user => 'plu', repo => 'Pithub', ref => 'tags' });
    my $result = $phub->git_data->references->update({ user => 'plu', repo => 'Pithub', { data => { ref => 'tags/v1.0', sha => 'df21b2660fb6' } } });
    my $result = $phub->git_data->tags->create({ user => 'plu', repo => 'Pithub', data => { message => 'some message' } });
    my $result = $phub->git_data->tags->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });
    my $result = $phub->git_data->trees->create({ user => 'plu', repo => 'Pithub', data => { base_tree => 'df21b2660fb6' } });
    my $result = $phub->git_data->trees->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });
    my $result = $phub->git_data->trees->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6', recursive => 1 });
    my $result = $phub->issues->comments->create({ repo => 'Pithub', user => 'plu', issue_id => 1, data => { body => 'some comment' } });
    my $result = $phub->issues->comments->delete({ repo => 'Pithub', user => 'plu', comment_id => 1 });
    my $result = $phub->issues->comments->get({ repo => 'Pithub', user => 'plu', comment_id => 1 });
    my $result = $phub->issues->comments->list({ repo => 'Pithub', user => 'plu', issue_id => 1 });
    my $result = $phub->issues->comments->update({ repo => 'Pithub', user => 'plu', comment_id => 1, data => { body => 'some comment' } });
    my $result = $phub->issues->create({ user => 'plu', 'repo' => 'Pithub', data => { title => 'bug: foo bar' } });
    my $result = $phub->issues->events->get({ repo => 'Pithub', user => 'plu', event_id => 1 });
    my $result = $phub->issues->events->list({ repo => 'Pithub', user => 'plu' });
    my $result = $phub->issues->events->list({ repo => 'Pithub', user => 'plu', issue_id => 1 });
    my $result = $phub->issues->get({ user => 'plu', 'repo' => 'Pithub', issue_id => 1 });
    my $result = $phub->issues->labels->create({ repo => 'Pithub', user => 'plu', data => { name => 'some label' } });
    my $result = $phub->issues->labels->create({ repo => 'Pithub', user => 'plu', issue_id => 1, data => { name => 'some label' } });
    my $result = $phub->issues->labels->delete({ repo => 'Pithub', user => 'plu', issue_id => 1 });
    my $result = $phub->issues->labels->delete({ repo => 'Pithub', user => 'plu', issue_id => 1, label_id => 1 });
    my $result = $phub->issues->labels->delete({ repo => 'Pithub', user => 'plu', label_id => 1 });
    my $result = $phub->issues->labels->get({ repo => 'Pithub', user => 'plu', label_id     => 1 });
    my $result = $phub->issues->labels->get({ repo => 'Pithub', user => 'plu', milestone_id => 1 });
    my $result = $phub->issues->labels->list({ repo => 'Pithub', user => 'plu' });
    my $result = $phub->issues->labels->list({ repo => 'Pithub', user => 'plu', issue_id => 1 });
    my $result = $phub->issues->labels->replace({ repo => 'Pithub', user => 'plu', issue_id => 1, data => { labels => [qw(label1 label2)] } });
    my $result = $phub->issues->labels->update({ repo => 'Pithub', user => 'plu', label_id => 1, data => { name => 'other label' } });
    my $result = $phub->issues->list({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->issues->milestones->create({ repo => 'Pithub', user => 'plu', data => { title => 'some milestone' } });
    my $result = $phub->issues->milestones->delete({ repo => 'Pithub', user => 'plu', milestone_id => 1 });
    my $result = $phub->issues->milestones->get({ repo => 'Pithub', user => 'plu', milestone_id => 1 });
    my $result = $phub->issues->milestones->list({ repo => 'Pithub', user => 'plu' });
    my $result = $phub->issues->milestones->update({ repo => 'Pithub', user => 'plu', data => { title => 'new title' } });
    my $result = $phub->issues->update({ user => 'plu', 'repo' => 'Pithub', issue_id => 1, { title => 'bug bar foo' } });
    my $result = $phub->orgs->get({ org => 'CPAN-API' });
    my $result = $phub->orgs->list({ user => 'plu' });
    my $result = $phub->orgs->members->conceal({ org => 'CPAN-API', user => 'plu' });
    my $result = $phub->orgs->members->delete({ org => 'CPAN-API', user => 'plu' });
    my $result = $phub->orgs->members->is_member({ org => 'CPAN-API', user => 'plu' });
    my $result = $phub->orgs->members->is_public({ org => 'CPAN-API', user => 'plu' });
    my $result = $phub->orgs->members->list({ org => 'CPAN-API' });
    my $result = $phub->orgs->members->list_public({ org => 'CPAN-API' });
    my $result = $phub->orgs->members->publicize({ org => 'CPAN-API', user => 'plu' });
    my $result = $phub->orgs->teams->add_member({ team_id => 1, user => 'plu' });
    my $result = $phub->orgs->teams->add_repo({ team_id => 1, repo => 'some_repo' });
    my $result = $phub->orgs->teams->create({ org => 'CPAN-API', data => { name => 'some team' } });
    my $result = $phub->orgs->teams->delete({ team_id => 1 });
    my $result = $phub->orgs->teams->get({ team_id => 1 });
    my $result = $phub->orgs->teams->get({ team_id => 1, repo => 'some_repo' });
    my $result = $phub->orgs->teams->is_member({ team_id => 1, user => 'plu' });
    my $result = $phub->orgs->teams->list({ org => 'CPAN-API' });
    my $result = $phub->orgs->teams->list_members({ team_id => 1 });
    my $result = $phub->orgs->teams->list_repos({ team_id => 1 });
    my $result = $phub->orgs->teams->remove_member({ team_id => 1, user => 'plu' });
    my $result = $phub->orgs->teams->remove_repo({ team_id => 1, repo => 'some_repo' });
    my $result = $phub->orgs->teams->update({ team_id => 1, data => { name => 'new team name' } });
    my $result = $phub->orgs->update({ org => 'CPAN-API', data => { name => 'cpan-api' } });
    my $result = $phub->pull_requests->comments->create({ repo => 'Pithub', user => 'plu', comment_id => 1 });
    my $result = $phub->pull_requests->comments->create({ repo => 'Pithub', user => 'plu', pull_request_id => 1, data => { body => 'some comment' } });
    my $result = $phub->pull_requests->comments->list({ repo => 'Pithub', user => 'plu', comment_id      => 1 });
    my $result = $phub->pull_requests->comments->list({ repo => 'Pithub', user => 'plu', pull_request_id => 1 });
    my $result = $phub->pull_requests->comments->update({ repo => 'Pithub', user => 'plu', comment_id => 1, data => { body => 'some updated comment' } });
    my $result = $phub->pull_requests->commits({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });
    my $result = $phub->pull_requests->create({ user => 'plu', 'repo' => 'Pithub', data => { title => 'pull this' } });
    my $result = $phub->pull_requests->files({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });
    my $result = $phub->pull_requests->get({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });
    my $result = $phub->pull_requests->is_merged({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });
    my $result = $phub->pull_requests->list({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->pull_requests->merge({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });
    my $result = $phub->pull_requests->update({ user => 'plu', 'repo' => 'Pithub', data => { title => 'pull that' } });
    my $result = $phub->repos->branches({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->collaborators->add({ user => 'plu', 'repo' => 'Pithub', collaborator => 'rbo' });
    my $result = $phub->repos->collaborators->is_collaborator({ user => 'plu', 'repo' => 'Pithub', collaborator => 'rbo' });
    my $result = $phub->repos->collaborators->list({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->collaborators->remove({ user => 'plu', 'repo' => 'Pithub', collaborator => 'rbo' });
    my $result = $phub->repos->commits->create_comment({ user => 'plu', 'repo' => 'Pithub', comment_id => 1 });
    my $result = $phub->repos->commits->create_comment({ user => 'plu', 'repo' => 'Pithub', sha => 'df21b2660fb6', data => { body => 'some comment' } });
    my $result = $phub->repos->commits->get({ user => 'plu', 'repo' => 'Pithub', sha => 'df21b2660fb6' });
    my $result = $phub->repos->commits->get_comment({ user => 'plu', 'repo' => 'Pithub', comment_id => 1 });
    my $result = $phub->repos->commits->list({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->commits->list_comments({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->commits->list_comments({ user => 'plu', 'repo' => 'Pithub', sha => 'df21b2660fb6' });
    my $result = $phub->repos->commits->update_comment({ user => 'plu', 'repo' => 'Pithub', comment_id => 1, data => { body => 'updated comment' } });
    my $result = $phub->repos->contributors({ user => 'plu', repo => 'Pithub' });
    my $result = $phub->repos->create({ user => 'plu', data => { name => 'some-thing' } });
    my $result = $phub->repos->downloads->create({ user => 'plu', 'repo' => 'Pithub', { name => 'some download' } });
    my $result = $phub->repos->downloads->delete({ user => 'plu', 'repo' => 'Pithub', download_id => 1 });
    my $result = $phub->repos->downloads->list({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->downloads->list({ user => 'plu', 'repo' => 'Pithub', download_id => 1 });
    my $result = $phub->repos->forks->create({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->forks->list({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->get({ user => 'plu', repo => 'Pithub' });
    my $result = $phub->repos->keys->create({ user => 'plu', 'repo' => 'Pithub', key_id => 1, data => { title => 'some key' } });
    my $result = $phub->repos->keys->delete({ user => 'plu', 'repo' => 'Pithub', key_id => 1 });
    my $result = $phub->repos->keys->get({ user => 'plu', 'repo' => 'Pithub', key_id => 1 });
    my $result = $phub->repos->keys->list({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->keys->update({ user => 'plu', 'repo' => 'Pithub', key_id => 1, data => { title => 'some new title' } });
    my $result = $phub->repos->languages({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->list({ user => 'plu' });
    my $result = $phub->repos->tags({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->teams({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->update({ user => 'plu', repo => 'Pithub', data => { name => 'Gearman-Driver' } });
    my $result = $phub->repos->watching->is_watching({ repo => 'Pithub', user => 'plu' });
    my $result = $phub->repos->watching->list_repos({ user => 'plu' });
    my $result = $phub->repos->watching->list_repos;
    my $result = $phub->repos->watching->list_watchers({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->watching->start_watching({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->watching->stop_watching({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->users->emails->add({'plu@cpan.org'});
    my $result = $phub->users->emails->add({ [ 'plu@cpan.org', 'plu@pqpq.de' ] });
    my $result = $phub->users->emails->delete({'plu@cpan.org'});
    my $result = $phub->users->emails->delete({ [ 'plu@cpan.org', 'plu@pqpq.de' ] });
    my $result = $phub->users->emails->list;
    my $result = $phub->users->followers->follow({ user => 'plu' });
    my $result = $phub->users->followers->is_following({ user => 'plu' });
    my $result = $phub->users->followers->list({ user => 'plu' });
    my $result = $phub->users->followers->list;
    my $result = $phub->users->followers->list_following({ user => 'plu' });
    my $result = $phub->users->followers->list_following;
    my $result = $phub->users->followers->unfollow({ user => 'plu' });
    my $result = $phub->users->get({ user => 'plu' });
    my $result = $phub->users->keys->create({ data => { title => 'some key' } });
    my $result = $phub->users->keys->delete({ key_id => 1 });
    my $result = $phub->users->keys->get({ key_id => 1 });
    my $result = $phub->users->keys->list;
    my $result = $phub->users->keys->update({ data => { title => 'some key' } });
    my $result = $phub->users->update({ email => 'plu@pqpq.de' });

=cut

__PACKAGE__->meta->make_immutable;

1;
