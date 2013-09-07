package Yomiuri::Config;
use strict;
use warnings;
use utf8;

use Yomiuri;
use Yomiuri::Utils ();

sub new {
    my ($class, $config) = @_;
    $config = $class->MERGE(+{ $class->DEFAULT }, $config);
    return bless +{ %$config } => $class;
}

sub MERGE {
    my ($class, $base, $child) = @_;
    my %child = %$child; ## shallow copy

    for my $key (keys %$base) {
        next unless exists $child{$key};

        my $method = $class->can("MERGE_$key") || 'MERGE_FALLBACK';
        my $child  = delete $child{$key};
        $base->{$key} = $class->$method($base->{$key}, $child);
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

sub MERGE_web {
    my ($class, $base, $child) = @_;
    my %child = %$child; ## shallow copy

    # hash
    for my $key (qw/plackup/) {
        next unless exists $child{$key};
        $base->{$key} = +{
            %{ $base->{$key}       },
            %{ delete $child{$key} },
        };
    }

    return +{
        %$base,
        %child,
    };
}

sub MERGE_FALLBACK {
    my ($class, $base, $child) = @_;
    return +{
        %$base,
        %$child,
    };
}

sub DEFAULT {
    return (
        blog => +{
            title       => 'Debug Blog',
            description => 'created by Yomiuri',
        },
        datetime => +{
            time_zone       => 'GMT',
            locale          => 'en',
            date_format     => '%Y-%m-%d',
            time_format     => '%H:%M:%S',
            datetime_format => '%Y-%m-%dT%H:%M:%S%z', ## ISO 8601
        },
        web => +{
            plackup => +{
                host => '127.0.0.1',
                port => 5000,
            },
            enable_reverse_proxy => 0,
            enable_static        => 1,
        },
        template => +{
            path     => [Yomiuri::Utils::dist_share('template')],
            cache    => 0,
            module   => [qw/Text::Xslate::Bridge::Star Yomiuri::View::Bridge/],
        },
        repository => +{
            version  => $Yomiuri::VERSION,
            htdocs   => Yomiuri::Utils::dist_share('htdocs'),
        },
    );
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my ($method) = $AUTOLOAD =~ /:([^:]+)$/;
    return $self->{$method};
}

1;
__END__
