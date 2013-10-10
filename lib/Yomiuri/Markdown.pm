package Yomiuri::Markdown;
use strict;
use warnings;
use utf8;

use Text::Markdown::Hoedown;

use Yomiuri::Utils;
use Log::Minimal qw/debugf infof warnf/;
use File::Basename;
use Text::Xslate::Util;

our $TAGS_AND_TITLE_RX = qr/
    \A\s*
    (?:\[([^\[\]]+)\]\s)* # tags
    \s*
    (.+?)                 # title
    \s*\z
/mx;
our $META_RX = qr/
    ^\s*
    ([-_a-zA-Z0-9]+) # meta key
    \s*:\s*
    (.+?)            # meta value
    \s*$
/mx;
our $EXTRACT_META_RX = qr/
    \A\s*
    ^-{3,}$
    (.+?)
    ^-{3,}$
/msx;

sub extract_meta {
    my ($class, $markdown) = @_;
    $markdown =~ s/$EXTRACT_META_RX//;
    my $meta_header = $1;

    my %meta;
    if ($meta_header) {
        $meta_header =~ s/^\s*$//msgx;
        %meta = $class->parse_meta($meta_header);
    }

    return ($markdown, \%meta);
}

sub extract_info_by_file {
    my ($class, $file) = @_;
    my $markdown = read_file($file);
    my $info = $class->extract_info_by_markdown($markdown);

    unless ($info->{name}) {
        my $name = basename($file);
        $name =~ s/\.(?:md|mkdn)$//;
        $info->{name} = $name;
    }

    return $info;
}

sub _gen_callbacks {
    my ($class, $meta) = @_;
    $meta ||= +{};

    my $toc_level = 0;
    my $cb = Text::Markdown::Hoedown::Callbacks->new();
    # $cb->normal_text(sub {
    #     my ($text) = @_;
    #
    #     infof '[normal_text] %s', $text;
    #     if (!%$meta) {
    #         %$meta = $class->parse_meta($text);
    #     }
    #
    #     return $text;
    # });
    $cb->header(sub {
        my ($text, $level) = @_;
        $text ||= '';

        if ($level == 1 && $text && !$meta->{title}) {
            my $res = $class->parse_title($text);
            %$meta = (%$meta, %$res);
            $text = $meta->{title};
        }

        infof '[h%d] %s', $level, $text;

        my $formated_text = sprintf '<h%d id="toc_%d">%s</h%d>', $level, $toc_level, Text::Xslate::Util::html_escape($text), $level;
        $toc_level++;
        return $formated_text;
    });

    return $cb;
}

sub extract_info_by_markdown {
    my ($class, $text) = @_;

    my $title_meta = +{};
    my $cb = $class->_gen_callbacks($title_meta);
    Text::Markdown::Hoedown::Markdown->new(0, 99, $cb)->render($text);

    die 'cannot extract meta.' unless $title_meta;
    my (undef, $meta) = $class->extract_meta($text);
    %$meta = (%$meta, %$title_meta);
    return $meta;
}

sub parse_title {
    my ($invocant, $text) = @_;

    if (my @matches = ($text =~ $TAGS_AND_TITLE_RX)) {
        my $title = pop @matches;
        my $tags  = [grep defined, @matches];
        return +{
            title => $title,
            tags  => $tags,
        };
    }
    else {
        warnf 'failed parse title. got: %s', $text;
        return;
    }
}

sub parse_meta {
    my ($class, $text) = @_;

    if (my %meta = ($text =~ /$META_RX/g)) {
        return %meta;
    }
    else {
        debugf 'failed parse meta. got: %s', $text;
        return;
    }
}

sub convert_to_html_by_file {
    my ($class, $file) = @_;
    my $markdown = read_file($file);
    return $class->convert_to_html($markdown);
}

sub convert_to_html {
    my ($class, $text) = @_;

    ($text) = $class->extract_meta($text);
    return Text::Markdown::Hoedown::markdown($text);
}

1;
__END__
