use strict;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib/";
use MyApp;
use Plack::Test;
use HTTP::Request::Common qw/GET POST/;

my $app = MyApp->new;

test_psgi $app->psgi, sub {
    my $cb  = shift;
    my $res = $cb->( GET('/') );
    is $res->code, 200;
    diag $res->content;
};

done_testing;
