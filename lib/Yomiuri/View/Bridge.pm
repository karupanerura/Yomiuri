package Yomiuri::View::Bridge;
use 5.008005;
use strict;
use warnings;

use parent qw/ Text::Xslate::Bridge /;

use Amon2::Declare;
use Text::Xslate::Util qw/html_builder/;
use URI;

use Yomiuri::Markdown;

__PACKAGE__->bridge(
    # nil      => \%nil_methods,
    # scalar   => \%scalar_methods,
    # array    => \%array_methods,
    # hash     => \%hash_methods,
    function => +{
        config             => sub { c()->config },
        markdown           => html_builder { Yomiuri::Markdown->convert_to_html(@_) },
        markdown_from_file => html_builder { Yomiuri::Markdown->convert_to_html_by_file(@_) },
        uri_for            => \&_uri_for,
        cool_uri_for       => \&_cool_uri_for,
    },
);

sub _uri_for {
    my ($path, $param) = @_;

    my $uri = URI->new;
    $uri->path($path);
    $uri->query_form(%$param, $uri->query_form) if $param;

    return $uri->as_string;
}

sub _cool_uri_for {
    my ($path_parts, $param) = @_;

    my $path = '/' . join '/', @$path_parts;
       $path =~ s{/index$}{/}g;

    return _uri_for($path, $param);
}


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

