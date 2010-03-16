package Noe::Dispatcher;
use strict;
use warnings;
use base qw/Exporter/;
use Scalar::Util qw/blessed/;
use Carp;
use HTTPx::Dispatcher::Rule;
our @EXPORT = qw/connect match get post/;

my $rules;

sub _push {
    push @$rules, HTTPx::Dispatcher::Rule->new(@_)
}

sub connect {
    _push( @_ );
}

sub get {
    my @args = @_;
    $args[1]->{conditions} = { method => 'GET' };
    _push( @args );
}

sub post {
    my @args = @_;
    $args[1]->{conditions} = { method => 'POST' };
    _push( @args );
}

# stolen from HTTPx::Dispatcher
sub match {
    my ( $class, $req ) = @_;
    for my $rule ( @$rules ) {
        if ( my $result = $rule->match($req) ) {
            return $result;
        }
    }
    return;
}

1;
