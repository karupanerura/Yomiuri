package Yomiuri::View;
use strict;
use warnings;
use utf8;
use Carp ();

use Text::Xslate 1.6001;

# setup view class
sub make_instance {
    my ($class, $context) = @_;
    Carp::croak("Usage: Yomiuri::View->make_instance(\$context_class)") if @_ != 2;

    my $view_conf = $context->config->template || +{};
    my $view      = Text::Xslate->new(%$view_conf);
    return $view;
}

1;
