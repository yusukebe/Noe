use MyApp;
use Plack::Builder;
use Plack::Middleware qw( Static );

my $app = MyApp->new();

builder {
    enable Plack::Middleware::Static 'rules' => [
        {
            path =>  qr{\.(?:png|jpg|gif|css|txt)$},
            root => './root/',
        }
    ];
    $app->psgi_handler;
};

__END__

