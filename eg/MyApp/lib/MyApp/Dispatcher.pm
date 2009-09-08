package MyApp::Dispatcher;
use Mouse;
use HTTPx::Dispatcher;

connect '' => {controller => 'Root', action => 'root'};
connect 'hi' => {controller => 'Root', action => 'hi'};

1;
