package Yomiuri::Cmd;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite ro => [qw/c/];

use Scalar::Util qw/weaken/;
use String::CamelCase qw/camelize/;

my $PACKAGE = __PACKAGE__;

sub new {
    my ($class, $c) = @_;
    my $self = bless +{ c => $c } => $class;
    weaken($self->{c});
    return $self;
}

sub cmd { shift->c->cmd(@_) }

sub child {
    my ($self, $cmd) = @_;
    return $self->{__instance_cache}{child}{$cmd} ||= do {
        my $class = ref $self;
        (my $base_cmd = $class) =~ s/^${PACKAGE}(?:::)?//;
        $cmd = sprintf '%s::%s', $base_cmd, camelize($cmd);
        $self->cmd($cmd);
    };
}

1;
__END__
