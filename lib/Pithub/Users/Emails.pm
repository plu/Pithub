package Pithub::Users::Emails;

use Moose;
use namespace::autoclean;

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

    my $result = $phub->users->emails->add({ emails => 'plu@cpan.org' });
    my $result = $phub->users->emails->add({ emails => ['plu@cpan.org', 'plu@pqpq.de'] });

=cut

sub add {
}

=head2 delete

=over

=item *

Delete email address(es)

    DELETE /user/emails

=back

Examples:

    my $result = $phub->users->emails->delete({'plu@cpan.org'});
    my $result = $phub->users->emails->delete({['plu@cpan.org', 'plu@pqpq.de']});

=cut

sub delete {
}

=head2 list

=over

=item *

List email addresses for a user

    GET /user/emails

=back

Examples:

    my $result = $phub->users->emails->list;

=cut

sub list {
}

__PACKAGE__->meta->make_immutable;

1;