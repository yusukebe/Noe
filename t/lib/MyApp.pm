package MyApp;
use base qw/Noe/;

sub setup_router {
    my $self = shift;
    my $r = $self->router;
    $r->connect( '/', { controller => 'Root', action => 'index' } );
    return $r;
}

1;
