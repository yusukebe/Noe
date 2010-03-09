package Noe::View::TMT;
use base 'Noe::View';
use strict;
use warnings;
use Text::MicroTemplate::Extended;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {
        include_path => $opt{include_path},
        file         => $opt{file} || 'index.mt',
        content_type => $opt{content_type} || 'text/html',
    }, $class;
    $self;
}

sub render {
    my ( $self, $args ) = @_;
    my $mt = Text::MicroTemplate::Extended->new(
        include_path  => $self->{include_path},
        template_args => $args,
    );
    my $html = $mt->render( $self->{file} );
    $self->build_response( $html, ['Content-Type' => $self->{content_type} ] );
}

1;
