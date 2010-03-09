package Noe::View::TT;
use base 'Noe::View';
use strict;
use warnings;
use Template;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {
        include_path => $opt{include_path},
        file         => $opt{file} || 'index.tt2',
        content_type => $opt{content_type} || 'text/html',
    }, $class;
    $self;
}

sub render {
    my ( $self, $args ) = @_;
    my $config = { INCLUDE_PATH => $self->{include_path}, };
    my $html;
    my $template = Template->new($config);
    $template->process( $self->{file}, $args, \$html );
    $self->build_response( $html, [ 'Content-Type' => $self->{content_type} ] );
}

1;
