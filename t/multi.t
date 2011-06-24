use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

# branches.t
# collaborators/list.t
# commits/list.t
# contributors.t
# downloads/list.t
# forks/list.t
# get.t
# keys/list.t
# languages.t
# pull_requests/list.t
# tags.t
# teams.t
# watching/list.t

BEGIN {
    use_ok('Pithub');
    use_ok('Pithub::PullRequests');
    use_ok('Pithub::Repos');
    use_ok('Pithub::Repos::Collaborators');
    use_ok('Pithub::Repos::Commits');
    use_ok('Pithub::Repos::Downloads');
    use_ok('Pithub::Repos::Forks');
    use_ok('Pithub::Repos::Keys');
    use_ok('Pithub::Repos::Watching');
}

throws_ok { Pithub->new->pull_requests->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::PullRequests->new->list } qr{Missing key in parameters: user}, 'No parameters';

throws_ok { Pithub->new->repos->collaborators->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos->new->collaborators->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos::Collaborators->new->list } qr{Missing key in parameters: user}, 'No parameters';

throws_ok { Pithub->new->repos->commits->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos->new->commits->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos::Commits->new->list } qr{Missing key in parameters: user}, 'No parameters';

throws_ok { Pithub->new->repos->downloads->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos->new->downloads->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos::Downloads->new->list } qr{Missing key in parameters: user}, 'No parameters';

throws_ok { Pithub->new->repos->forks->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos->new->forks->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos::Forks->new->list } qr{Missing key in parameters: user}, 'No parameters';

throws_ok { Pithub->new->repos->keys->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos->new->keys->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos::Keys->new->list } qr{Missing key in parameters: user}, 'No parameters';

throws_ok { Pithub->new->repos->watching->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos->new->watching->list } qr{Missing key in parameters: user}, 'No parameters';
throws_ok { Pithub::Repos::Watching->new->list } qr{Missing key in parameters: user}, 'No parameters';

throws_ok { Pithub->new->pull_requests->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::PullRequests->new->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';

throws_ok { Pithub->new->repos->collaborators->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos->new->collaborators->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos::Collaborators->new->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';

throws_ok { Pithub->new->repos->commits->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos->new->commits->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos::Commits->new->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';

throws_ok { Pithub->new->repos->downloads->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos->new->downloads->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos::Downloads->new->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';

throws_ok { Pithub->new->repos->forks->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos->new->forks->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos::Forks->new->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';

throws_ok { Pithub->new->repos->keys->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos->new->keys->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos::Keys->new->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';

throws_ok { Pithub->new->repos->watching->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos->new->watching->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';
throws_ok { Pithub::Repos::Watching->new->list( user => 'plu' ) } qr{Missing key in parameters: repo}, 'No repo parameter';

# c_args => constructor args
# m_args => method args
my @tests = (
    {
        c_args => { token => 1 },
        m_args => { user  => 'plu', repo => 'Pithub' },
    },
    {
        c_args => { token => 1, user => 'plu', },
        m_args => { repo  => 'Pithub' },
    },
    {
        c_args => { token => 1, repo => 'Pithub' },
        m_args => { user  => 'plu', },
    },
    {
        c_args => { token => 1, user => 'plu', repo => 'Pithub' },
        m_args => {},
    },
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->pull_requests->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/pulls',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::PullRequests', %$c_args )->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/pulls',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->collaborators->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/collaborators',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->collaborators->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/collaborators',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos::Collaborators', %$c_args )->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/collaborators',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->commits->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/commits',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->commits->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/commits',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos::Commits', %$c_args )->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/commits',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->downloads->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/downloads',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->downloads->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/downloads',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos::Downloads', %$c_args )->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/downloads',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->forks->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/forks',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->forks->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/forks',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos::Forks', %$c_args )->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/forks',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->keys->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/keys',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->keys->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/keys',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos::Keys', %$c_args )->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/keys',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->watching->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/watchers',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->watching->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/watchers',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos::Watching', %$c_args )->list(%$m_args);
    },
    path  => '/repos/plu/Pithub/watchers',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->branches(%$m_args);
    },
    path  => '/repos/plu/Pithub/branches',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->branches(%$m_args);
    },
    path  => '/repos/plu/Pithub/branches',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->contributors(%$m_args);
    },
    path  => '/repos/plu/Pithub/contributors',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->contributors(%$m_args);
    },
    path  => '/repos/plu/Pithub/contributors',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->languages(%$m_args);
    },
    path  => '/repos/plu/Pithub/languages',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->languages(%$m_args);
    },
    path  => '/repos/plu/Pithub/languages',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->tags(%$m_args);
    },
    path  => '/repos/plu/Pithub/tags',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->tags(%$m_args);
    },
    path  => '/repos/plu/Pithub/tags',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub', %$c_args )->repos->teams(%$m_args);
    },
    path  => '/repos/plu/Pithub/teams',
    tests => \@tests,
);

test(
    code => sub {
        my ( $c_args, $m_args ) = @_;
        return Pithub::Test->create( 'Pithub::Repos', %$c_args )->teams(%$m_args);
    },
    path  => '/repos/plu/Pithub/teams',
    tests => \@tests,
);

sub test {
    my (%args) = @_;
    foreach my $test ( @{ $args{tests} } ) {
        my $result = $args{code}->( $test->{c_args}, $test->{m_args} );
        is $result->request->method, 'GET', "HTTP method for $args{path}";
        is $result->request->uri->path, $args{path}, "HTTP path for $args{path}";
    }
}

done_testing;
