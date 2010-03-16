package TestApp::Controller::Root;
sub index {
    my ( $self, $c ) = @_;
    $c->render( 'index', {} );
}
