package MyApp::Controller::Root;
use Mouse;
with 'Noe::Controller';

sub root {
    my $req = shift;
    render('index.tt2');
}

1;

__END__
