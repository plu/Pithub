package    # hide from PAUSE
  Pithub::Test::UA;

use Moo;
use Path::Tiny;
use HTTP::Response;
use Test::More;

my @responses;

sub add_response {
    my ( $self, $path ) = @_;
    my $full_path = sprintf '%s/http_response/api.github.com/%s', path(__FILE__)->dirname, $path;
    my $response_string = path($full_path)->slurp;
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
