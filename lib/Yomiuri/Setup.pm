package Yomiuri::Setup;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite
    ro  => [qw/dir flavor/],
    new => 1;

use Git::Repository;
use Log::Minimal;
use Yomiuri::Utils qw/write_file YOMIURI_REPOSITORY_DIR/;

sub mkdir :method {
    my $self = shift;
    my $dir  = File::Spec->catfile($self->dir, @_);

    infof "[mkdir]\t$dir";
    mkdir $dir;
}

sub touch {
    my $self = shift;
    Yomiuri::Utils::touch( File::Spec->catfile($self->dir, @_) );
}

sub write :method {
    my ($self, $pathlist, $data) = @_;
    my $path = File::Spec->catfile($self->dir, @$pathlist);

    infof "[write]\t$path";
    write_file($path, $data);
}

sub run {
    my $self = shift;

    # mkdir
    $self->mkdir();
    $self->mkdir(YOMIURI_REPOSITORY_DIR);

    # setup
    $self->setup_config();
    $self->setup_psgi();
    $self->setup_htdocs();
    $self->setup_entry();
    $self->setup_template();
    $self->setup_git();

    return $self;
}

sub setup_config {
    my $self = shift;

    my $data = $self->flavor->get('config.toml');
    $self->write([YOMIURI_REPOSITORY_DIR, 'config.toml'] => $data);
}

sub setup_psgi {
    my $self = shift;

    my $data = $self->flavor->get('app.psgi');
    $self->write([YOMIURI_REPOSITORY_DIR, 'app.psgi'] => $data);
}

sub setup_git {
    my $self = shift;

    infof "[git]\tinit";
    Git::Repository->run(init => $self->dir);

    my $git = Git::Repository->new(work_tree => $self->dir);
    infof "[git]\tadd .";
    $git->run(add => '.');
}

sub setup_htdocs {
    my $self = shift;
    $self->mkdir('htdocs');
    $self->touch('htdocs', '.gitkeep');
}

sub setup_entry {
    my $self = shift;
    $self->mkdir('entry');
    $self->touch('entry', '.gitkeep');

    my $data = $self->flavor->get('sample.md');
    $self->write(['entry', 'sample.md'] => $data);
}

sub setup_template {
    my $self = shift;
    $self->mkdir('template');
    $self->touch('template', '.gitkeep');
}

1;
