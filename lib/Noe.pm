package Noe;
use strict;
use warnings;
use Router::Simple;
use Noe::Util qw/dumper/;
use Noe::Request;
use Noe::Response;

our $VERSION = '0.02';

sub setup_route { die "This is abstract method: route" };
sub router {
    return Router::Simple->new;
}

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless \%opt, $class;
    $self->{_router} ||= $self->setup_route();
    return $self;
}

sub app {
    my $self = shift;
    return sub {
        my $env = shift;
        my $route = $self->dispatch($env);
        dumper $route;
    };
}

sub dispatch {
    my ( $self, $env ) = @_;
    return $self->router->match($env);
}

1;

__END__

=head1 NAME

Noe::Web

=head1 SYNOPSIS

in MyApp/Web.pm

    package MyApp::Web;
    use parent qw/Noe::Web/;
    1;

in myapp.psgi

    use MyApp::Web;
    my $web = MyApp::Web->new;
    $web->app;

