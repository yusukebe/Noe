package MyApp::Controller::Root;
use Mouse;
use Encode;

no Mouse;

sub root {
    my ( $self, $c  ) = @_;
    $c->render('index.tt2', { message => $c->config->{message} } );
}

sub hi {
    my ( $self, $c ) = @_;
    my $name = $c->req->param('name') || 'nanashi';
    $name = decode_utf8( $name );
    $c->render('hi.tt2', { name => $name } );
}

sub redirect {
    my ($self, $c ) = @_;
    $c->redirect( $c->base );
}

sub error {}

__PACKAGE__->mata->make_immutable;
1;
