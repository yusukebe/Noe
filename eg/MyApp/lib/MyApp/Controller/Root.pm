package MyApp::Controller::Root;
use Mouse;
with 'Noe::Controller';

sub root {
    my ( $self, $c  ) = @_;
    $c->render('index.tt2');
}

sub hi {
    my ( $self, $c ) = @_;
    my $name = $c->request->param('name') || 'nanashi';
    $c->render('hi.tt2', { name => $name } );
}

1;

