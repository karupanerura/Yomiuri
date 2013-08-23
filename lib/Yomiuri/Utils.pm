package Yomiuri::Utils;
use strict;
use warnings;
use utf8;

use parent qw/Exporter/;
our @EXPORT = qw/dist_share encoding touch write_file read_file md5_file search_project_dir YOMIURI_REPOSITORY_DIR/;

use Encode;
use Cwd qw/getcwd realpath/;
use File::Basename qw/dirname/;
use File::ShareDir qw/dist_dir/;
use File::Spec;
use Scalar::Util qw/blessed/;

use constant BASE_PATH => $ENV{KAWARA_PRODUCTION} ?
    dist_dir('Yomiuri'):
    realpath( File::Spec->rel2abs('../../share', dirname(__FILE__)) );

use constant YOMIURI_REPOSITORY_DIR => '.yomiuri';

sub dist_share {
    return File::Spec->catfile(BASE_PATH, @_);
}

{
    our $ENCODING = Encode::find_encoding('utf-8');
    sub encoding { $ENCODING }
    sub io_layer {
        return 'raw' unless defined $ENCODING;
        return sprintf 'encoding(%s)', (
               blessed($ENCODING)
            && $ENCODING->isa('Encode::Encoding')
            && $ENCODING->perlio_ok
        ) ? $ENCODING->name : $ENCODING;
    }
}

sub touch {
    my ($file) = @_;
    open my $fh, '>>', $file or die "file: $file, error: $!";
    close $fh or die $!;
}

sub write_file {
    my ($file, $data) = @_;

    my $io_layer = io_layer();
    open my $fh, ">:$io_layer", $file or die "file: $file, error: $!";
    print {$fh} $data;
    close $fh or die $!;
}

sub read_file {
    my ($file) = @_;

    my $io_layer = io_layer();
    open my $fh, "<:$io_layer", $file or die "file: $file, error: $!";
    my $data = do {
        local $/;
        <$fh>;
    };
    close $fh or die $!;

    return $data;
}

sub md5_file { Digest::MD5::md5_base64(read_file(@_)) }

sub search_project_dir {
    my $cwd     = getcwd();
    my $repodir = File::Spec->catfile($cwd, YOMIURI_REPOSITORY_DIR);
    return $cwd if -d $repodir;

    my @directories = File::Spec->splitdir($cwd);
    while (@directories and not -d $repodir) {
        pop @directories;
        $cwd = File::Spec->catdir(@directories);
        $repodir = File::Spec->catfile($cwd, YOMIURI_REPOSITORY_DIR);
    }
    die "not in project dir. (cwd: @{[ getcwd() ]})" unless -d $repodir;

    pop @directories;
    return File::Spec->canonpath(File::Spec->catdir(@directories));
}

1;
__END__
