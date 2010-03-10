use MyApp;
use Plack::Builder;

my $app = MyApp->new();

builder {
    enable "Plack::Middleware::Static",
      path => qr{^/static},
      root => './root/';
    $app->psgi_handler;
};