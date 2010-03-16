use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Plack::Request;
use TestApp::Dispatcher;

use_ok('Noe::Dispatcher');

{
    my $req =
      Plack::Request->new(
        { PATH_INFO => '/', REQUEST_METHOD => 'GET', } );
    my $rule = TestApp::Dispatcher->match($req);
    is_deeply( $rule,
        { controller => 'Root', args => {}, action => 'index' } );
}

{
    my $req =
      Plack::Request->new(
        { PATH_INFO => '/comment', REQUEST_METHOD => 'GET', } );
    my $rule = TestApp::Dispatcher->match($req);
    is_deeply( $rule,
        { controller => 'Comment', args => {}, action => 'show' } );
}

{
    my $req =
      Plack::Request->new( { PATH_INFO => '/comment', REQUEST_METHOD => 'POST', } );
    my $rule = TestApp::Dispatcher->match( $req );
    is_deeply( $rule,
        { controller => 'Comment', args => {}, action => 'post' } );
}

done_testing;
