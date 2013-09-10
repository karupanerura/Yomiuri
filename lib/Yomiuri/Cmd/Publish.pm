package Yomiuri::Cmd::Publish;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use File::Spec;
use Yomiuri::Utils;

use Yomiuri::Web::C::Root;

sub run {
    my ($self, $opts) = @_;

    my $dir = search_project_dir();
    write_file(File::Spec->catfile($dir, 'htdocs', 'index.html'), Yomiuri::Web::C::Root->index($self->c));
}

1;
__END__
