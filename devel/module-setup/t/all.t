use Module::Setup::Test::Flavor;

run_flavor_test {
    default_dialog;
    name 'MyApp';
    flavor '+DevelTestFlavor';
    file 'myapp.yaml' => qr/message/;

    file 'myapp.psgi' => qr/MyApp/, qr/Plack::Builder/;

    file 'root/static/css/screen.css' => qr/Blueprint/;

    file 'root/static/css/print.css' => qr/Blueprint/;

    file 'root/static/css/ie.css' => qr/Blueprint/;

    file 'root/static/css/LICENSE' => qr/Blueprint/;

    file 'tmpl/index.mt' => qr/html/;

    file 'lib/MyApp.pm' => qr/Noe/;

    file 'lib/MyApp/Dispatcher.pm' => qr/Noe::Dispatcher/;

    file 'lib/MyApp/Controller/Root.pm' => qr/Controller::Root/;
    dirs qw( root );
};
