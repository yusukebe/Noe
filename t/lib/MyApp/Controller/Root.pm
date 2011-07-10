package MyApp::Controller::Root;
use base 'Noe::Controller';

sub index {
    my $self = shift;
    $self->render('index');
}

1;
