package Noe::Plack::Adapter;
use Mouse;
use Plack::Request;
use Path::Class;
use UNIVERSAL::require;

has app => ( is => 'ro', isa => 'Str', required => 1 );
has base_dir => (
    is         => 'rw',
    isa        => 'Path::Class::Dir',
    lazy_build => 1,
);

sub _build_base_dir {
    my $self = shift;
    my $p    = $self->app() . ".pm";
    $p =~ s!::!/!g;
    my $path = $INC{$p};
    $path =~ s!lib/$p$!!;
    dir($path);
}

sub BUILDARGS {
    my ( $class, $app ) = @_;
    return +{ app => $app };
}

sub handler {
    my $self = shift;
    return sub {
        my $req = Plack::Request->new(shift);
        local *Noe::c = sub { $self };
        my $app        = $self->app;
        my $dispatcher = "${app}::Dispatcher";
        $dispatcher->require or die "can't find dispatcher";
        my $rule = $dispatcher->match($req);
        my $controller = "${app}::Controller::$rule->{controller}";
        $controller->require;
        my $method = $rule->{action} or die "unknown action: $rule->{action}";
        return $controller->$method($req);
    }
}

1;
__END__
