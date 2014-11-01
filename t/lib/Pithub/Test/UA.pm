package    # hide from PAUSE
  Pithub::Test::UA;

use Moo;
use File::Basename qw(dirname);
use File::Slurp qw(read_file);
use HTTP::Response;
use Test::More;

my @responses;

sub add_response {
    my ( $self, $path ) = @_;
    my $full_path = sprintf '%s/http_response/api.github.com/%s', dirname(__FILE__), $path;
    my $response_string = read_file($full_path);
    my $response = HTTP::Response->parse($response_string);
    push @responses, $response;
}

sub request {
    my ( $self, $request ) = @_;
    my $result = HTTP::Response->new;
    if ( my $response = shift(@responses) ) {
        $result = $response;
    }
    $result->request($request);
    return $result;
}

1;
