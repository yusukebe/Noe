package Noe::View;
use strict;
use warnings;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {}, $class;
    $self;
}

sub build_response {
    my ( $self, $content, $header ) = @_;
    my $length = length $content;
    push @$header, ( 'Content-Length' => $length );
    return [ 200, $header, [$content] ];
}

1;
