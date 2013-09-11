package Yomiuri::Cmd::Entry;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use Log::Minimal qw/infof/;
use Yomiuri::Model::Entry;

sub model {
    my $self = shift;
    return $self->{__model} ||= Yomiuri::Model::Entry->new;
}

sub add {
    my ($self, $opts, @files) = @_;
    for my $file (@files) {
        die "$file not found." unless -f $file;
        my $status = $self->model->add($file);
        infof "[%s]\t%s", $status, $file if $status;
    }
}

sub list {
    my ($self, $opts) = @_;
    print "[$_->{id}] $_->{title}\n" for $self->model->list();
}

sub remove {
    my ($self, $opts, @files) = @_;
    for my $file (@files) {
        $self->model->remove($file);
    }
}

1;
__END__
