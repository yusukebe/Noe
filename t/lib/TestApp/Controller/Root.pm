package TestApp::Controller::Root;
use Mouse;
no Mouse;

sub root {
    my ( $self, $c ) = @_;
    $c->render( 'index.tt2', {} );
}
