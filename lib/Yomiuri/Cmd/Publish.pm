package Yomiuri::Cmd::Publish;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use File::Spec;
use File::Find qw/find/;
use Yomiuri::Utils;

use Yomiuri::Web::C::Root;

sub run {
    my ($self, $opts) = @_;

    my $dir = search_project_dir();
    $self->prepare($opts, $dir);
    $self->render($opts, $dir);
}

sub prepare {
    my ($self, $opts, $dir) = @_;
    return if $opts->{'no-prepare'};

    my $entry = $self->cmd('Entry');
    find +{
        no_chdir => 1,
        wanted   => sub {
            $entry->add($opts, $_) if -f $_ && $_ =~ /\.(?:md|mkdn)$/;
        },
    } => File::Spec->catfile($dir, 'entry');
}

sub render {
    my ($self, $opts, $dir) = @_;
    return if $opts->{'no-render'};

    my $htdocs = File::Spec->catfile($dir, 'htdocs');

    write_file(File::Spec->catfile($htdocs, 'index.html'), Yomiuri::Web::C::Root->index($self->c));
}

1;
__END__
