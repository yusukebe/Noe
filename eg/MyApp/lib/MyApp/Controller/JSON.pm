package MyApp::Controller::JSON;

sub index {
    my ( $self, $c ) = @_;
    $c->render( { as => 'JSON' }, { message => $c->config->{message} } );
}

1;
