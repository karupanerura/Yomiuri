package Yomiuri::Cmd::Publish;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use File::Spec;
use File::Find qw/find/;

use Yomiuri::Utils;
use Yomiuri::Model::Entry;

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

    # index
    write_file(File::Spec->catfile($htdocs, 'index.html'), Yomiuri::Web::C::Root->index($self->c));

    # entry/show
    my $entry_dir = File::Spec->catfile($htdocs, 'entry');
    mkdir $entry_dir unless -d $entry_dir;
    for my $entry (Yomiuri::Model::Entry->new->list) {
        my $file = $entry->{file};
        my $path = File::Spec->catfile($entry_dir, "$entry->{name}.html");
        my $html = Yomiuri::Web::C::Entry->show($self->c => +{ name => $entry->{name} });
        write_file($path, $html);
    }
}

1;
__END__
