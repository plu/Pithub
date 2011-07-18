package Pithub::GitData;

# ABSTRACT: Github v3 Git Data API

use Moo;
use Carp qw(croak);
use Pithub::GitData::Blobs;
use Pithub::GitData::Commits;
use Pithub::GitData::References;
use Pithub::GitData::Tags;
use Pithub::GitData::Trees;
extends 'Pithub::Base';

sub blobs {
    return shift->_create_instance('Pithub::GitData::Blobs');
}

sub commits {
    return shift->_create_instance('Pithub::GitData::Commits');
}

sub references {
    return shift->_create_instance('Pithub::GitData::References');
}

sub tags {
    return shift->_create_instance('Pithub::GitData::Tags');
}

sub trees {
    return shift->_create_instance('Pithub::GitData::Trees');
}

1;
