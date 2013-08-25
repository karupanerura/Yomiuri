package Yomiuri::Cmd::Entry;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use Yomiuri::Model::Entry;

sub model {
    my $self = shift;
    return $self->{__model} ||= Yomiuri::Model::Entry->new;
}

sub add {
    my ($self, $opts, $file) = @_;
    die "$file not found." unless -f $file;
    $self->model->add($file);
}

sub list {
    my ($self, $opts) = @_;
    print "[$_->{id}] $_->{title}\n" for $self->model->list();
}

sub remove {
    my ($self, $opts, $name) = @_;
    $self->model->remove($name);
}

1;
__END__
