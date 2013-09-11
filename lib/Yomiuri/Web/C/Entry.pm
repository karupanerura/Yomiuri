package Yomiuri::Web::C::Entry;
use strict;
use warnings;
use utf8;

use Yomiuri::Model::Entry;

sub show :method {
    my ($class, $c, $args) = @_;

    my $id = $args->{id};

    my $entry = Yomiuri::Model::Entry->new;
    return $c->render('entry/show.tx' => +{
        entry => $entry->get_by_id($id),
    });
}

1;
__END__
