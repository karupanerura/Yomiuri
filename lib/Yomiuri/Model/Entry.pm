package Yomiuri::Model::Entry;
use strict;
use warnings;
use utf8;

use parent qw/ Yomiuri::Model /;
sub default { +{ list => [] } }

use File::Basename qw/basename/;
use List::MoreUtils qw/any firstval/;

use Yomiuri::Markdown;
use Yomiuri::Utils;

sub add {
    my ($self, $file) = @_;
    $file = to_project_relative_path($file);
    my $md5   = md5_file($file);
    my $meta  = Yomiuri::Markdown->extract_info_by_file($file);
    my $index = $self->get_by_md5($md5) || $self->get_by_name($meta->{name}) || $self->get_by_file($file);

    my $status;
    if ($index) {
        # refetch for get not shallow copied hash object
        $index = $self->get_by_id($index->{id});

        if ($index->{name} ne $meta->{name}) {
            $index->{name} = $meta->{name};
            $status = 'renamed';
        }
        if ($index->{file} ne $file) {
            $index->{file} = $file;
            $status = 'moved';
        }
        if ($index->{md5} ne $md5) {
            $index = +{
                %$meta,
                %$index,
                md5 => $md5,
            };
            $status = 'modified';
        }
    }
    else {
        push @{ $self->{list} } => +{
            %$meta,
            id    => scalar(@{ $self->{list} }) + 1,
            file  => $file,
            md5   => md5_file($file),
        };
        $status = 'added';
    }

    $self->save;
    return $status;
}

sub get_by_id {
    my ($self, $id) = @_;
    return $self->{list}->[$id-1];
}

sub get_by_file {
    my ($self, $file) = @_;
    return firstval { $_->{file} eq $file } $self->list;
}

sub get_by_md5 {
    my ($self, $md5) = @_;
    return firstval { $_->{md5} eq $md5 } $self->list;
}

sub get_by_name {
    my ($self, $name) = @_;
    return firstval { $_->{name} eq $name } $self->list;
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
    return map { +{ %$_ } } @{ $self->{list} };
}

sub remove {
    my ($self, $file) = @_;
    my $index = $self->get_by_file($file);

    return unless $index;
    delete $self->{list}->[$index->{id}-1];
    $self->save;
}

1;
__END__
