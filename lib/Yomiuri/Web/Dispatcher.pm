package Yomiuri::Web::Dispatcher;
use strict;
use warnings;
use utf8;

use Amon2::Web::Dispatcher::RouterSimple;

connect '/'                                 => 'Root#index';
connect '/entry/{name:[-_a-zA-Z0-9]+}.html' => 'Entry#show';

1;
