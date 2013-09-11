package Yomiuri::Flavor::Default;
use strict;
use warnings;
use utf8;

use parent qw/ Yomiuri::Flavor::Base /;

1;
__DATA__
@@ config.toml.tx
: block blog -> {
[blog]
title       = "<: $name :>"
description = "the great <: $name :> blog."
: }

: block datetime -> {
[datetime]
# using for timestamp.
# time_zone:       time_zone for DateTime.      see also: perldoc DateTime::TimeZone
# locale:          locale for DateTime.         see also: perldoc DateTime::Locale
# date_format:     stftime format for DateTime. see also: perldoc DateTime
# time_format:     stftime format for DateTime. see also: perldoc DateTime
# datetime_format: stftime format for DateTime. see also: perldoc DateTime
time_zone       = "Asia/Tokyo"
locale          = "ja"
date_format     = "%Y-%m-%d"
time_format     = "%H:%M:%S"
datetime_format = "%Y-%m-%dT%H:%M:%S%z"
: }

: block web -> {
[web]
[web.plackup]
# preview web server settings
host = "127.0.0.1"
port = 3000
: }

: block template -> {
[template]
# using for Text::Xslate constructor setting
path = ["template"]
: }

: block repository -> {
[repository]
# repository version
version = <: $ver :>
# htdocs setting
htdocs  = "htdocs"
: }

@@ app.psgi.tx
use strict;
use warnings;
use utf8;

use Yomiuri::Web;
use Plack::Builder;

my $config = Yomiuri::Web->config;
builder {
    : block middlewate -> {
    enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } 'ReverseProxy';
    enable 'Static' => (
        path => qr{^/(?:img|css|js|meta)/},
        root => $config->{repository}->{htdocs},
    );
    : }
    Yomiuri::Web->to_app();
};

@@ sample.md.tx
This is sample entry.
==============================

Hi. This is sample weblog entry of Yomiuri.

# h1
## h2
### h3
hellooooooooooooooo!!!!!

yeah!!!!!!!!!!!!!!!!!!!!!!!!
-----------------------------
goodbye!!!
