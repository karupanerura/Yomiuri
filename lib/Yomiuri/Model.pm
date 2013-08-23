package Yomiuri::Model;
use strict;
use warnings;
use utf8;

use JSON 2;
use File::Spec;
use String::CamelCase qw/decamelize/;

use Yomiuri::Utils qw/write_file read_file search_project_dir YOMIURI_REPOSITORY_DIR/;

my $json = JSON->new->ascii(1);

sub dir  { File::Spec->catfile($_[0]->project_dir, YOMIURI_REPOSITORY_DIR()) }
sub path { File::Spec->catfile($_[0]->dir,         $_[0]->file) }

sub file {
    my $invocant = shift;
    my $class    = ref $invocant || $invocant;

    (my $name = $class) =~ s/^\QYomiuri::Model:://;

    my $file = sprintf '%s.json', decamelize($name);
    {
        no strict 'refs';
        *{"${class}::file"} = sub { $file };
    }

    return $file;
}

sub project_dir {
    my $invocant    = shift;
    my $project_dir = search_project_dir();

    my $class = ref $invocant || $invocant;
    {
        no strict 'refs';
        *{"${class}::project_dir"} = sub { $project_dir };
    }

    return $project_dir;
}

sub default { +{} }

sub new {
    my $class = shift;
    my $data  = $class->load;
    return bless $data => $class;
}

sub load {
    my $class = shift;
    return $class->default unless -d $class->dir;
    return $class->default unless -f $class->path;

    my $text = read_file($class->path);
    return $json->decode($text);
}

sub save {
    my $self = shift;
    write_file($self->path, $json->encode(+{ %$self }));
}

sub DESTROY {
    my $self = shift;
    $self->save;
}

1;
