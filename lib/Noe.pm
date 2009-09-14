package Noe;
use Mouse;
our $VERSION = '0.01';
use Plack::Request;
use Path::Class;
use UNIVERSAL::require;

has 'app' => ( is => 'ro', isa => 'Str', required => 1 );

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
    $path =~ s!lib/$p$!\.!;
    dir($path);
}

sub BUILDARGS {
    my ( $class ) = shift;
    return { app => $class };
}

sub setup {}

sub psgi_handler {
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

=head1 NAME

Noe -

=head1 SYNOPSIS

  use Noe;

=head1 DESCRIPTION

Noe is

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut