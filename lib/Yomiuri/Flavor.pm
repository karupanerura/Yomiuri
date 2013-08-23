package Yomiuri::Flavor;
use strict;
use warnings;
use utf8;

use Class::Load qw/load_class/;

sub new {
    my ($class, $flavor_name) = @_;
    my $klass = ($flavor_name =~ s/^\+//) ? $flavor_name : "Yomiuri::Flavor::${flavor_name}";
    load_class($klass);
    return $klass->new;
}

1;
