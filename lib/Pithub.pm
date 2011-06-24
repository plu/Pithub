package Pithub;

# ABSTRACT: Github v3 API

use Moose;
use Class::MOP;
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Gists' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::GitData' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Issues' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Orgs' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::PullRequests' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Repos' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Users' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub

=head1 SYNOPSIS

    use Pithub;

=cut

__PACKAGE__->meta->make_immutable;

1;
