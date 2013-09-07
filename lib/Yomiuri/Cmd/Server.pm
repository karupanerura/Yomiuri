package Yomiuri::Cmd::Server;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use Plack::Loader;
use Plack::Util;
use Yomiuri::Web;

sub run {
    my ($self, $opts) = @_;
    my $config = $self->c->config;

    my $app = Plack::Util::load_psgi( Yomiuri::Web->psgi_path() );
    Plack::Loader->auto(%{ $config->{web}->{plackup} })->run($app);
}

1;
__END__
