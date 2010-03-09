package MyApp::Controller::Root;

sub index {
    my ( $self, $c  ) = @_;
    $c->render('index', { message => $c->config->{message} } );
}

sub hi {
    my ( $self, $c ) = @_;
    my $name = $c->req->param('name') || 'nanashi';
    $c->render('hi', { name => $name } );
}

sub redirect {
    my ($self, $c ) = @_;
    $c->redirect( $c->base );
}

sub error {}

1;
