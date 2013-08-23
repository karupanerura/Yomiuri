package Yomiuri::Model::Category;
use strict;
use warnings;
use utf8;

use parent qw/ Yomiuri::Model /;

sub add {
    my ($self, $name) = @_;
    $self->{$name} = 1;
    $self->save;
}

sub list {
    my $self = shift;
    return keys %$self;
}

sub remove {
    my ($self, $name) = @_;
    delete $self->{$name};
    $self->save;
}

1;
__END__
