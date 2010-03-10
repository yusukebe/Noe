package MyApp::Controller::Root;

sub index {
    my ( $self, $c ) = @_;
    $c->render( 'index', { message => $c->config->{message} } );
}

1;
