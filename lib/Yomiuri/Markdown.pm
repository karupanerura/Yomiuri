package Yomiuri::Markdown;
use strict;
use warnings;
use utf8;

use Text::Markdown::Discount;
Text::Markdown::Discount::with_html5_tags();

use Yomiuri::Utils;

sub extract_title_by_file {
    my ($class, $file) = @_;
    my $markdown = read_file($file);
    return $class->extract_title_by_markdown($markdown);
}

sub extract_titles_by_file {
    my ($class, $file) = @_;
    my $markdown = read_file($file);
    return $class->extract_titles_by_markdown($markdown);
}

sub extract_title_by_markdown  { (shift->extract_titles_by_markdown(@_))[0] }
sub extract_titles_by_markdown {
    my ($class, $text) = @_;

    my @title;
    while ($text =~ m/(?:^(.+)$(?=(?:[\r\n]|\r\n)^=+$)|^#(?:\s+|[^#])(.+)$)/mgo) {
        push @title => $1 || $2;
    }

    die 'cannot extract title.' unless @title;
    return @title;
}

sub convert_to_html {
    my ($class, $text) = @_;
    return Text::Markdown::Discount::markdown($text);
}

1;
__END__
