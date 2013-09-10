package Yomiuri::Web::Dispatcher;
use strict;
use warnings;
use utf8;

use Amon2::Web::Dispatcher::RouterSimple;

connect '/' => 'Root#index';

1;
