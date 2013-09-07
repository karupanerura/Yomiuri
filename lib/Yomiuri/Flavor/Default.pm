package Yomiuri::Flavor::Default;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri::Flavor::Base/;

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
# preview web server settings
bind                 = "127.0.0.1:3000"
enable_reverse_proxy = false # true  if using reverse proxy. see also: Plack::Middleware::ReverseProxy
enable_static        = true  # false if using static another content server.
: }

: block template -> {
[template]
# using for Text::Xslate constructor setting
: }

: block repository -> {
[repository]
# repository version
version = <: $ver :>
# htdocs setting
htdocs  = "htdocs"
: }
