package MyApp::Dispatcher;
use Mouse;
use HTTPx::Dispatcher;

connect '' => {controller => 'Root', action => 'root'};

1;
