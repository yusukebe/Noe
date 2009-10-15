use MyApp;
use Plack::Builder;

my $app = MyApp->new();

builder {
    enable "Plack::Middleware::Static",
      path => qr{\.(?:png|jpg|gif|css|txt|js)$},
      root => 'root/';
    $app->psgi_handler;
};

__END__

