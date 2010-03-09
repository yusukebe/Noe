package Noe::View::JSON;
use base 'Noe::View';
use strict;
use warnings;
use JSON::XS;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {}, $class;
    $self;
}

sub render {
    my ( $self, $args ) = @_;
    my $json = JSON::XS->new->utf8->encode( $args );
    $self->build_response( $json, [ 'Content-Type' => 'application/json' ] );
}

1;
