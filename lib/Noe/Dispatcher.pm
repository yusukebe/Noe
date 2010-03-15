package Noe::Dispatcher;
use strict;
use warnings;
use HTTPx::Dispatcher;
our @EXPORT = qw/connect match/;

# XXX
*match = \&HTTPx::Dispatcher::match;
*connect = \&HTTPx::Dispatcher::connect;

1;
