package Yomiuri::Config;
use strict;
use warnings;
use utf8;

use Yomiuri::Utils;

use TOML;
use File::Spec;
use Class::Load qw/load_class/;
use Class::Accessor::Lite ro => [qw/datetime htdocs template/];

sub new {
    my ($class, $config) = @_;
    $class = delete $config->{config_class} if exists $config->{config_class};
    load_class($class);

    $config = $class->merge_default(+{ $class->default }, $config);
    return bless +{ %$config } => $class;
}

sub load_file {
    my ($class, $file) = @_;
    my $path = File::Spec->catfile(search_project_dir(), $file);
    die "cannot find ${file}." unless -f $path;

    my $source = read_file($path);
    return $class->load($source);
}

sub load {
    my ($class, $source) = @_;
    my $config = TOML::from_toml($source);
    return $class->new($config);
}

sub merge_default {
    my ($class, $base, $child) = @_;
    my %child = %$child; ## shallow copy

    for my $key (keys %$base) {
        next unless exists $child{$key};

        my $method = $class->can("MERGE_$key");
        if ($method) {
            my $child = delete $child{$key};
            $base->{$key} = $class->$method($base->{$key}, $child);
        }
    }

    return +{
        %$base,
        %child,
    };
}

sub MERGE_htdocs {
    my ($class, $base, $child) = @_;
    my %child = %$child; ## shallow copy

    # array
    for my $key (qw/path/) {
        next unless exists $child{$key};
        $base->{$key} = [
            @{ delete $child{$key} },
            @{ $base->{$key}         },
        ];
    }

    return +{
        %$base,
        %child,
    };
}

sub MERGE_template {
    my ($class, $base, $child) = @_;
    my %child = %$child; ## shallow copy

    # array
    for my $key (qw/path module html_builder_module/) {
        next unless exists $child{$key};
        $base->{$key} = [
            @{ delete $child{$key} },
            @{ $base->{$key}         },
        ];
    }

    return +{
        %$base,
        %child,
    };
}

sub default {
    return (
        datetime => +{
            time_zone       => 'GMT',
            locale          => 'en',
            date_format     => '%Y-%m-%d',
            time_format     => '%H:%M:%S',
            datetime_format => '%Y-%m-%dT%H:%M:%S%z', ## ISO 8601
        },
        htdocs   => +{
            path     => [dist_share('htdocs')],
        },
        template => +{
            path     => [dist_share('template')],
            cache    => 0,
            module   => [qw/Text::Xslate::Bridge::Star Yomiuri::View::Bridge/],
        },
    );
}

1;
__END__
