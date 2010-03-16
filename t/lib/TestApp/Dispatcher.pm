package TestApp::Dispatcher;
use Noe::Dispatcher;

connect '' => { controller => 'Root', action => 'index' };
get '/comment' => { controller => 'Comment', action => 'show' };
post '/comment' => { controller => 'Comment', action => 'post' };

1;
