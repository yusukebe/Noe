package MyApp::Dispatcher;
use HTTPx::Dispatcher;

connect ''         => { controller => 'Root', action => 'index' };
connect 'hi'       => { controller => 'Root', action => 'hi' };
connect 'redirect' => { controller => 'Root', action => 'redirect' };
connect 'error'    => { controller => 'Root', action => 'error' };
connnet 'json'     => { controoler => 'JSON', action => 'index' };

1;
