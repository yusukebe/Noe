package Noe::Web;
use strict;
use warnings;

our $VERSION = '0.02';

sub new {
    my ( $class, %opt ) = @_;
}

sub app {
    
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

