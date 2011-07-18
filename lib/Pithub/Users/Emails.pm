package Pithub::Users::Emails;

# ABSTRACT: Github v3 User Emails API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method add

=over

=item *

Add email address(es)

    POST /user/emails

Examples:

    my $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    my $result = $e->add( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=back

=cut

sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    return $self->request(
        method => 'POST',
        path   => '/user/emails',
        %args,
    );
}

=method delete

=over

=item *

Delete email address(es)

    DELETE /user/emails

Examples:

    my $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    my $result = $e->delete( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    return $self->request(
        method => 'DELETE',
        path   => '/user/emails',
        %args,
    );
}

=method list

=over

=item *

List email addresses for a user

    GET /user/emails

Examples:

    my $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    my $result = $e->list;

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    return $self->request(
        method => 'GET',
        path   => '/user/emails',
        %args,
    );
}

1;
