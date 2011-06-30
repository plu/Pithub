package    # hide from PAUSE
  Pithub::Test;

use strict;
use warnings;
use Pithub::Test::UA;

sub create {
    my ( $self, $class, %args ) = @_;
    return $class->new( ua => Pithub::Test::UA->new, %args );
}

1;
