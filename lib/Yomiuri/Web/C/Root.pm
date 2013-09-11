package Yomiuri::Web::C::Root;
use strict;
use warnings;
use utf8;

use Yomiuri::Model::Entry;

sub index :method {
    my ($class, $c) = @_;

    my $entry = Yomiuri::Model::Entry->new;
    return $c->render('index.tx' => +{
        entries => [ $entry->list ],
    });
}

1;
__END__
