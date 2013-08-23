package Yomiuri::Model::Category;
use strict;
use warnings;
use utf8;

use parent qw/ Yomiuri::Model /;

sub add {
    my ($self, $name) = @_;
    $self->{$name} = 1;
}

sub list {
    my $self = shift;
    return keys %$self;
}

sub remove {
    my ($self, $name) = @_;
    delete $self->{$name};
}

1;
__END__
