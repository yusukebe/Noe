package TestApp::Dispatcher;
use HTTPx::Dispatcher;
connect '' => {controller => 'Root', action => 'root'};
1;
