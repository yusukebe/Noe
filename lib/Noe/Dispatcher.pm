package Noe::Dispatcher;
use HTTPx::Dispatcher;
our @EXPORT = qw/connect match/;

# XXX
*match = \&HTTPx::Dispatcher::match;
*connect = \&HTTPx::Dispatcher::connect;

1;
