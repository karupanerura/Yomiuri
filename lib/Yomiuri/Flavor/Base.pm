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
                } @{ mro::get_linear_isa(ref $self) }
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
