package Yomiuri;
use 5.008005;
use strict;
use warnings;
use utf8;

our $VERSION = "0.01";

use parent qw/Amon2/;

use Cwd;
use Class::Load qw/load_class/;
use File::Spec;

use Yomiuri::Config::Loader;
use Yomiuri::View;
use Yomiuri::Utils ();

sub load_config      { Yomiuri::Config::Loader->load_file(shift->load_config_from) }
sub load_config_from { File::Spec->catfile(Yomiuri::Utils::search_project_dir(), '.yomiuri', 'config.toml') }

sub cmd {
    my ($self, $cmd) = @_;
    return $self->{__instance_cache}{cmd}{$cmd} ||= do {
        my $klass = sprintf '%s::Cmd::%s', __PACKAGE__, $cmd;
        load_class($klass);
        $klass->new($self);
    };
}

sub view {
    my $invocant = shift;
    my $class    = ref $invocant || $invocant;

    my $view = Yomiuri::View->make_instance($class);
    {
        no strict 'refs'; ## no critic
        no warnings 'redefine';
        *{"${class}::view"} = sub { $view };
    }

    return $view;
}

1;
__END__

=encoding utf-8

=head1 NAME

Yomiuri - It's new $module

=head1 SYNOPSIS

    use Yomiuri;

=head1 DESCRIPTION

Yomiuri is ...

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut

