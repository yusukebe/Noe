#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib ("$FindBin::Bin/../lib", "$FindBin::Bin/../../../lib");
use MyApp;
use Plack::Impl::FCGI;

my $app = MyApp->new;
my $server = Plack::Impl::FCGI->new(
  listen => '/tmp/myapp.socket'
);
$server->run($app->psgi_handler);

1;

__END__
