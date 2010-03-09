use strict;
use warnings;
use Test::More;
use t::Utils;
use_ok('TestApp');

my $app     = TestApp->new();
my $env     = {
    'psgi.version'    => [ 1, 0 ],
    'psgi.url_scheme' => 'http',
    REQUEST_METHOD    => 'GET',
    SERVER_PROTOCOL   => 'HTTP/1.1',
    SERVER_PORT       => 80,
    SERVER_NAME       => 'example.com',
    SCRIPT_NAME       => '/',
    PATH_INFO         => '/',
    REMOTE_ADDR       => '127.0.0.1',
};
my $psgi_handler = $app->psgi_handler;
my $res = $psgi_handler->($env);
is_deeply $res,
  [
    '200', [ 'Content-Type' => 'text/html', 'Content-Length' => 11 ],
    ['Hello World']
  ] , 'Got Hello World;' ;

done_testing;
