package TestApp::Controller::Root;
sub root {
    my ( $self, $c ) = @_;
    $c->render( 'index', {} );
}
