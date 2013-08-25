package Yomiuri::Model::Entry;
use strict;
use warnings;
use utf8;

use parent qw/ Yomiuri::Model /;
sub default { +{ list => [] } }

use List::MoreUtils qw/any firstval/;

use Yomiuri::Markdown;
use Yomiuri::Utils;

sub add {
    my ($self, $file) = @_;
    $file = to_project_relative_path($file);

    my $id;
    if (my $index = $self->get_by_file($file)) {
        my $md5 = md5_file($file);
        if ($index->{md5} ne $md5) {
            $index->{md5}   = $md5;
            $index->{title} = Yomiuri::Markdown->extract_title_by_file($file);
        }
        $id = $index->{id};
    }
    else {
        push @{ $self->{list} } => +{
            id    => scalar(@{ $self->{list} }) + 1,
            file  => $file,
            md5   => md5_file($file),
            title => Yomiuri::Markdown->extract_title_by_file($file),
        };
        $id = $self->{list}->[-1]->{id};
    }

    $self->save;
    return $id;
}

sub get_by_id {
    my ($self, $id) = @_;
    return $self->{list}->[$id-1];
}

sub get_by_file {
    my ($self, $file) = @_;
    return firstval { $_->{file} eq $file } $self->list;
}

sub is_exists {
    my ($self, $file) = @_;
    return any { $_->{file} eq $file } $self->list;
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
