package Yomiuri::Web::C::Entry;
use strict;
use warnings;
use utf8;

use Yomiuri::Model::Entry;

sub show :method {
    my ($class, $c, $args) = @_;

    my $name = $args->{name};

    my $entry = Yomiuri::Model::Entry->new;
    return $c->render('entry/show.tx' => +{
        entry => $entry->get_by_name($name),
    });
}

1;
__END__
