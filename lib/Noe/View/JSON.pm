package Noe::View::JSON;
use base 'Noe::View';
use strict;
use warnings;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {}, $class;
    $self;
}

sub render {
  my ( $self, $args ) = @_;
}

1;
