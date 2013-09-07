package Yomiuri::Config::Loader;
use strict;
use warnings;
use utf8;

use Yomiuri::Utils;

use TOML;
use File::Spec;
use Class::Load qw/load_class/;

sub load_file {
    my ($class, $path) = @_;
    die "cannot find ${path}." unless -f $path;

    my $source = read_file($path);
    return $class->load($source);
}

sub load {
    my ($class, $source) = @_;
    my ($config, $err) = TOML::from_toml($source);
    die $err if defined $err;

    my $config_class = exists $config->{config_class} ?
        delete $config->{config_class}:
        'Yomiuri::Config';
    load_class($config_class);

    return $config_class->new($config);
}

1;
__END__
