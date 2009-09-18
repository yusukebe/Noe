package MyApp::Dispatcher;
use Mouse;
use HTTPx::Dispatcher;

connect '' => {controller => 'Root', action => 'root'};
connect 'hi' => {controller => 'Root', action => 'hi'};
connect 'redirect' => { controller => 'Root', action => 'redirect' };
connect 'error' => { controller => 'Root', action => 'error' };

1;
