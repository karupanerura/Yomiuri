package Yomiuri::Model::Index;
use strict;
use warnings;
use utf8;

use parent qw/ Yomiuri::Model /;
sub default { +{ list => [] } }

use List::MoreUtils qw/any firstval/;
use Yomiuri::Utils;

sub add {
    my ($self, $file) = @_;

    if (my $index = $self->get($file)) {
        $index->{md5} = md5_file($file);
    }
    else {
        push @{ $self->{list} } => +{
            file => $file,
            md5  => md5_file($file),
        };
    }

    $self->save;
}

sub is_exists {
    my ($self, $file) = @_;
    return any { $_->{file} eq $file } $self->list;
}

sub get {
    my ($self, $file) = @_;
    return firstval { $_->{file} eq $file } $self->list;
}

sub is_changed {
    my ($self, $file) = @_;
    my $index = $self->get($file);
    return 0 unless $index;
    return $index->{md5} ne md5_file($file) ? 1 : 0;
}

sub list {
    my $self = shift;
    return @{ $self->{list} };
}

1;
__END__
