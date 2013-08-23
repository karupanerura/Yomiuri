package Yomiuri::Flavor::Base;
use strict;
use warnings;
use utf8;

use Data::Section::Simple;
use Text::Xslate;

use if $] >= 5.009_005, 'mro';
use if $]  < 5.009_005, 'MRO::Compat';

sub new {
    my $class = shift;
    my %args  = (@_ == 1 && ref $_[0] eq 'HASH') ? %{+shift} : @_;
    return bless +{ default => \%args } => $class;
}

sub xslate {
    my $self = shift;
    return $self->{__instance_cache}{xslate} ||= do {
        Text::Xslate->new(
            cache => 0,
            type  => 'text',
            path  => [
                map {
                    Data::Section::Simple->new($_)->get_data_section()
                } reverse @{ mro::get_linear_isa(ref $self) }
            ],
        );
    };
}

sub get {
    my ($self, $file, $args) = @_;
    $args ||= +{};

    my $template = sprintf '%s.tx', $file;
    return $self->xslate->render($template => +{
        %{$self->{default}},
        %$args,
    });
}

1;
__DATA__
@@ config.toml.tx
[datetime]
# using for timestamp.
# time_zone:       time_zone for DateTime.      see also: perldoc DateTime::TimeZone
# locale:          locale for DateTime.         see also: perldoc DateTime::Locale
# date_format:     stftime format for DateTime. see also: perldoc DateTime
# time_format:     stftime format for DateTime. see also: perldoc DateTime
# datetime_format: stftime format for DateTime. see also: perldoc DateTime
time_zone       = "Asia/Tokyo"
locale          = "ja"
date_format     = "%Y-%m-%d"
time_format     = "%H:%M:%S"
datetime_format = "%Y-%m-%dT%H:%M:%S%z"

[template]
# using for Text::Xslate constructor setting

[htdocs]
# htdocs setting
path = ['htdocs']
