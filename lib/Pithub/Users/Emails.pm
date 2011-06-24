package Pithub::Users::Emails;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Users::Emails

=head1 METHODS

=head2 add

=over

=item *

Add email address(es)

    POST /user/emails

=back

Examples:

    $p      = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->add('plu@cpan.org');
    $result = $p->users->emails->add( [ 'plu@cpan.org', 'plu@pqpq.de' ] );

    $e      = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->add('plu@cpan.org');
    $result = $e->add( [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=cut

sub add {
    my ( $self, $email ) = @_;
    croak 'Missing parameter: $email (string or arrayref)' unless $email;
    $email = [$email] unless ref $email eq 'ARRAY';
    return $self->request( POST => '/user/emails', $email );
}

=head2 delete

=over

=item *

Delete email address(es)

    DELETE /user/emails

=back

Examples:

    $p      = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->delete('plu@cpan.org');
    $result = $p->users->emails->delete( [ 'plu@cpan.org', 'plu@pqpq.de' ] );

    $e      = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->delete('plu@cpan.org');
    $result = $e->delete( [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=cut

sub delete {
    my ( $self, $email ) = @_;
    croak 'Missing parameter: $email (string or arrayref)' unless $email;
    $email = [$email] unless ref $email eq 'ARRAY';
    return $self->request( DELETE => '/user/emails', $email );
}

=head2 list

=over

=item *

List email addresses for a user

    GET /user/emails

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->list;

    $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->list;

=cut

sub list {
    my ($self) = @_;
    return $self->request( GET => '/user/emails' );
}

__PACKAGE__->meta->make_immutable;

1;
