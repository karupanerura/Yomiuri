package Yomiuri::CLI;
use 5.008005;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri/;

use Yomiuri::Web::C;

sub render {
    my ($self, $tmpl, $args) = @_;
    $args ||= +{};
    return $self->view->render($tmpl, $args);
}

1;
