package Yomiuri::Cmd::Category;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use Yomiuri::Model::Category;

sub model {
    my $self = shift;
    return $self->{__model} ||= Yomiuri::Model::Category->new;
}

sub add {
    my ($self, $opts, $name) = @_;
    $self->model->add($name);
}

sub list {
    my ($self, $opts) = @_;
    print $_, "\n" for $self->model->list();
}

sub remove {
    my ($self, $opts, $name) = @_;
    $self->model->remove($name);
}

1;
__END__
