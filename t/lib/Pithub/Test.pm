package    # hide from PAUSE
  Pithub::Test;

use strict;
use warnings;
use File::Basename qw(dirname);
use File::Slurp qw(read_file);

sub create {
    my ( $self, $class, %args ) = @_;
    return $class->new( skip_request => defined $ENV{PITHUB_TEST_SKIP_REQUEST} ? $ENV{PITHUB_TEST_SKIP_REQUEST} : 1, %args );
}

sub get_response {
    my ( $self, $file ) = @_;
    my $path = sprintf '%s/Test/http_response/%s', dirname(__FILE__), $file;
    my $http_response = read_file($path);
    return $http_response;
}

1;
