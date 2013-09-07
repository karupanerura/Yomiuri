package Yomiuri::Cmd::Server;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use Plack::Builder;
use Plack::Loader;
use Yomiuri::Web;

sub run {
    my ($self, $opts) = @_;
    my $config = $self->c->config;

    my $app = builder {
        enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } 'ReverseProxy' if $config->{web}->{enable_reverse_proxy};
        if ($config->{web}->{enable_static}) {
            enable 'Static' => (
                path => qr{^/(?:img|css|js|meta)/},
                root => $config->{repository}->{htdocs},
            );
        }

        Yomiuri::Web->to_app();
    };

    Plack::Loader->auto(%{ $config->{web}->{plackup} })->run($app);
}

1;
__END__
