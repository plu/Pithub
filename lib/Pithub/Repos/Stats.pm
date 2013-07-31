package Pithub::Repos::Stats;

# ABSTRACT: Github v3 repos / stats API

use Moo;

extends 'Pithub::Base';

=method contributors

List contributors with stats

    GET /repos/:user/:repo/stats/contributors

Examples:

    my $repos  = Pithub::Repos::Stats->new;
    my $result = $repos->contributors( user => 'plu', repo => 'Pithub' );

=cut

sub contributors {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    my $req = {
        method => 'GET',
        path => sprintf(
            '/repos/%s/%s/stats/contributors',
            delete $args{user}, delete $args{repo}
        ),
        %args
    };
    my $res = $self->request(
        %$req
    );

    while ($res->response->code == 202) {
        warn "202 response, sleeping and redoing..";
        sleep 5;
        $res = $self->request(%$req);
    }
    return $res;
}



1;
