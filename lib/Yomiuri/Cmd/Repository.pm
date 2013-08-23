package Yomiuri::Cmd::Repository;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Cmd/;

use Cwd qw/getcwd/;
use File::Spec;

use Yomiuri::Setup;
use Yomiuri::Flavor;

sub create {
    my ($self, $opts, $dir) = @_;
    $dir ||= getcwd();

    my $flavor_name = $opts->{flavor} || 'Default';
    my $flavor      = Yomiuri::Flavor->new($flavor_name => +{
        dir => $dir,
    });

    Yomiuri::Setup->new(
        flavor => $flavor,
        dir    => $dir,
    )->run;
}

1;
__END__
