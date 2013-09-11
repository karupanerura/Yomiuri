package Yomiuri::Web::Dispatcher;
use strict;
use warnings;
use utf8;

use Amon2::Web::Dispatcher::RouterSimple;


use Module::Find qw/useall/;
useall 'Yomiuri::Web::C';

connect '/' => 'Root#index';

1;
