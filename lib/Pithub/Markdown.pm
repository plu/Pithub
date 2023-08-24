package Pithub::Markdown;
our $VERSION = '0.01042';

# ABSTRACT: Github v3 Markdown API

use Moo;
use Carp qw( croak );
extends 'Pithub::Base';

has [qw( mode context )] => ( is => 'rw' );

=attr mode

The rendering mode. Can be either:

=over

=item *

C<markdown> to render a document in plain Markdown, just like README.md
files are rendered.

=item *

C<gfm> to render a document in GitHub Flavored Markdown, which creates
links for user mentions as well as references to SHA-1 hashes, issues,
and pull requests.

=back

=attr context

The repository context to use when creating references in C<gfm> mode.
Omit this parameter when using C<markdown> mode.

=method render

Render an arbitrary Markdown document

    POST /markdown

Example:

    use Pithub::Markdown;

    my $response = Pithub::Markdown->new->render(
        data => {
            text => "Hello world github/linguist#1 **cool**, and #1!",
            context => "github/gollum",
            mode => "gfm",
        },
    );

    # Note that response is NOT in JSON, so ->content will die
    my $html = $response->raw_content;

=cut

sub render {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)'
        unless defined $args{data};

    for (qw( context mode )) {
        $args{data}{$_} = $self->$_ if !exists $args{data}{$_} and $self->$_;
    }

    return $self->request(
        method => 'POST',
        path   => '/markdown',
        %args,
    );
}

1;
