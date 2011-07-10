package Noe;
use strict;
use warnings;
use Router::Simple;
use Noe::Util qw//;
use Noe::Request;
use Noe::Response;
use Plack::Util;

our $VERSION = '0.02';

sub setup_router { die "This is abstract method: setup_router" };
sub router {
    return Router::Simple->new;
}

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless \%opt, $class;
    $self->{_router} ||= $self->setup_router();
    return $self;
}

sub psgi {
    my $self = shift;
    return sub {
        my $env = shift;
        my $route = $self->dispatch($env);
        return $self->res_404 unless $route;
        my $class = Plack::Util::load_class( "Controller::$route->{controller}", ref $self );
        my $method = $route->{action};
        my $code = $class->$method;
        return $code;
    };
}

sub res_404 {
    return [404, [ 'Content-Type' => 'text/plain' ], ['404 Not Found']];
}

sub dispatch {
    my ( $self, $env ) = @_;
    return $self->{_router}->match($env);
}

1;

__END__

=head1 NAME

Noe

=head1 SYNOPSIS

