package    # hide from PAUSE
  Pithub::Test::Factory;

use strict;
use warnings;
use Pithub::Test::UA;

sub create {
    my ( $self, $class, %args ) = @_;
    return $class->new( ua => Pithub::Test::UA->new, %args );
}

sub test_account {
    return {
        org      => 'buhtip-org',
        org_repo => 'buhtip-org-repo',
        repo     => 'buhtip-repo',
        user     => 'buhtip',
    };
}

1;
