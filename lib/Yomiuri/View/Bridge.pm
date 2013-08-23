package Yomiuri::View::Bridge;
use 5.008005;
use strict;
use warnings;

use parent qw/ Text::Xslate::Bridge /;

use Amon2::Declare;

__PACKAGE__->bridge(
    # nil      => \%nil_methods,
    # scalar   => \%scalar_methods,
    # array    => \%array_methods,
    # hash     => \%hash_methods,
    function => +{
        config => sub { c()->config },
    },
);

1;
__END__

=encoding utf-8

=head1 NAME

Yomiuri::View::Bridge - It's new $module

=head1 SYNOPSIS

    use Yomiuri::View::Bridge;

=head1 DESCRIPTION

Yomiuri::View::Bridge is ...

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut

