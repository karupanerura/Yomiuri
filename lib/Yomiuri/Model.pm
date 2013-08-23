package Yomiuri::Model;
use strict;
use warnings;
use utf8;

use JSON 2;
use File::Spec;
use String::CamelCase qw/decamelize/;

use Yomiuri::Utils qw/write_file read_file search_project_dir YOMIURI_REPOSITORY_DIR/;

my $json = JSON->new->ascii(1);

sub dir  { File::Spec->catfile(search_project_dir(), YOMIURI_REPOSITORY_DIR()) }
sub path { File::Spec->catfile($_[0]->dir,           $_[0]->file) }

sub file {
    my $invocant = shift;
    my $class    = ref $invocant || $invocant;

    die "${class}::file is abstruct method. cannot use direct." if $class eq __PACKAGE__;
    (my $name = $class) =~ s/^\QYomiuri::Model:://;

    my $file = sprintf '%s.json', decamelize($name);
    {
        no strict 'refs'; ## no critic
        *{"${class}::file"} = sub { $file };
    }

    return $file;
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
