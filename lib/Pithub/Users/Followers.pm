package Pithub::Users::Followers;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Users::Followers

=head1 METHODS

=head2 follow

=over

=item *

Follow a user

    PUT /user/following/:user

=back

Examples:

    my $result = $phub->users->followers->follow({ user => 'plu' });

=cut

sub follow {
}

=head2 is_following

=over

=item *

Check if the authenticated user is following another given user

    GET /user/following/:user

=back

Examples:

    my $result = $phub->users->followers->is_following({ user => 'plu' });

=cut

sub is_following {
}

=head2 list

=over

=item *

List a user's followers:

    GET /users/:user/followers

=item *

List the authenticated user's followers:

    GET /user/followers

=back

Examples:

    my $result = $phub->users->followers->list({ user => 'plu' });
    my $result = $phub->users->followers->list;

=cut

sub list {
}

=head2 list_following

=over

=item *

List who a user is following:

    GET /users/:user/following

=item *

List who the authenicated user is following:

    GET /user/following

=back

Examples:

    my $result = $phub->users->followers->list_following({ user => 'plu' });
    my $result = $phub->users->followers->list_following;

=cut

sub list_following {
}

=head2 unfollow

=over

=item *

Unfollow a user

    DELETE /user/following/:user

=back

Examples:

    my $result = $phub->users->followers->unfollow({ user => 'plu' });

=cut

sub unfollow {
}

__PACKAGE__->meta->make_immutable;

1;
