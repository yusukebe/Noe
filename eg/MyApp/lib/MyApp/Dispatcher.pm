package MyApp::Dispatcher;
use Noe::Dispatcher;

connect ''         => { controller => 'Root', action => 'index' };
connect 'hi'       => { controller => 'Root', action => 'hi' };
connect 'redirect' => { controller => 'Root', action => 'redirect' };
connect 'error'    => { controller => 'Root', action => 'error' };
connect 'json'     => { controller => 'JSON', action => 'index' };

1;
