package MyApp::Controller::Root;
use Mouse;
with 'Noe::Controller';

sub root {
    my ( $self, $c  ) = @_;
    $c->render('index.tt2', { message => $c->config->{message} } );
}

sub hi {
    my ( $self, $c ) = @_;
    my $name = $c->req->param('name') || 'nanashi';
    $c->render('hi.tt2', { name => $name } );
}

sub redirect {
    my ($self, $c ) = @_;
    $c->redirect( $c->req->uri->base );
}

1;

