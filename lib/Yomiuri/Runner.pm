package Yomiuri::Runner;
use strict;
use warnings;
use utf8;

use Config;
use Getopt::Compact::WithCmd ();
use String::CamelCase qw/camelize/;
use List::MoreUtils qw/apply/;
use Term::ANSIColor;
use Log::Minimal;

use Yomiuri;
use Yomiuri::Cmd::Repository;

use Class::Accessor::Lite ro => [qw/getopt/];

sub version { $Yomiuri::VERSION }

sub appname {
    my $self = shift;
    require File::Basename;
    return File::Basename::basename($0);
}

sub getopt_parser {
    my $class = shift;
    return Getopt::Compact::WithCmd->new(
        name          => $class->appname,
        version       => $class->version,
        args          => 'FILE',
        global_struct => [
            [ [qw/help h/],    'print help.',    '!', undef, +{} ],
            [ [qw/version v/], 'print version.', '!', undef, +{} ],
            [ [qw/no-color/],  'no color.',      '!', undef, +{} ],
        ],
        command_struct => +{
            create => +{
                desc    => 'create new blog.',
                args    => 'Dir',
                options => [
                    [ [qw/flavor/], 'Yomiuri::Flavor', '=s', undef, { default => 'Default' } ],
                ],
            },
            publish => +{
                desc => 'publish html.',
            },
            server => +{
                desc        => 'start server.',
                other_usage => 'serve published static blog entries and dynamic publish with watch directory.',
            },
            category => +{
                desc           => 'category edit.',
                args           => 'add|list|remove',
                command_struct => +{
                    add => +{
                        desc => 'add category.',
                        args => 'name',
                    },
                    list => +{
                        desc => 'list category.',
                        args => '',
                    },
                    remove => +{
                        desc => 'remove category.',
                        args => 'name',
                    },
                },
            },
            entry => +{
                desc           => 'entry edit.',
                args           => 'add|list|remove',
                command_struct => +{
                    add => +{
                        desc => 'add entry.',
                        args => 'name',
                    },
                    list => +{
                        desc => 'list entry.',
                        args => '',
                    },
                    remove => +{
                        desc => 'remove entry.',
                        args => 'name',
                    },
                },
            },
        },
    );
}

sub new {
    my $class = shift;
    local @ARGV = @_;

    my $getopt = $class->getopt_parser;
    die $getopt->usage unless $getopt->is_success;

    return bless +{ getopt => $getopt }, $class;
}

sub run {
    my $self = shift;

    local $Log::Minimal::COLOR = !$self->getopt->opts->{'no-color'} ? 1 : 0;
    local $Log::Minimal::PRINT = sub {
        my ($time, $type, $message, $trace, $raw_message) = @_;

        unless ($Log::Minimal::COLOR) {
            my $lc_type = lc($type);
            $type = Term::ANSIColor::color($Log::Minimal::DEFAULT_COLOR->{$lc_type}->{text})
                . $type . Term::ANSIColor::color('reset')
                    if $Log::Minimal::DEFAULT_COLOR->{$lc_type}->{text};
            $type = Term::ANSIColor::color("on_$Log::Minimal::DEFAULT_COLOR->{$lc_type}->{background}")
                . $type . Term::ANSIColor::color('reset')
                    if $Log::Minimal::DEFAULT_COLOR->{$lc_type}->{background};
        }

        $message =~ s/\\t/\x09/g;
        printf "%s [%s] %s\n", $time, $type, $message;
    };

    if ($self->getopt->opts->{help}) {
        print $self->getopt->usage unless $self->getopt->is_success;
    }
    elsif ($self->getopt->opts->{version}) {
        print $self->version_message();
    }
    else {
        my $yomiuri = Yomiuri->bootstrap();
        my ($cmd, @sub_methods) = apply { tr/-/_/ } @{$self->getopt->commands};
        my $run_method = pop @sub_methods;
        if (!$run_method) {
            if (Yomiuri::Cmd::Repository->can($cmd)) {
                $run_method = $cmd;
                $cmd        = 'repository';
            }
            else {
                $run_method = 'run';
            }
        }

        my $current = $yomiuri->cmd( camelize($cmd) );
        $current = $current->child($_) for @sub_methods;
        $current->$run_method($self->getopt->opts, @{ $self->getopt->args });
    }

    return;
}

sub version_message {
    my $self = shift;

    return sprintf <<"__VER__", $self->appname(), ref($self), $self->version, $^V, $Config::Config{archname};
%s
	%s/%s
	perl/%vd on %s
__VER__
}

1;
__END__
