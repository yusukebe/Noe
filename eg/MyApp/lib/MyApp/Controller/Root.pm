package MyApp::Controller::Root;
use Mouse;
with 'Noe::Controller';

sub root {
    my ( $self, $req  ) = @_;
    render('index.tt2');
}

sub hi {
    my ( $self, $req ) = @_;
    my $name = $req->param('name') || 'nanashi';
    render('hi.tt2', { name => $name } );
}

1;

__END__
