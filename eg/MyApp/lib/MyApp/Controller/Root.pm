package MyApp::Controller::Root;

sub index {
    my $self = shift;
    render( 'index', { message => $c->config->{message} } );
}

1;
