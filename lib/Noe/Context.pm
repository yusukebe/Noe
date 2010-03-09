package Noe::Context;
use strict;
use Text::MicroTemplate::Extended;
use URI;
use YAML::XS;
use UNIVERSAL::require;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {
        request  => $opt{request},
        base_dir => $opt{base_dir},
        app      => $opt{app},
        base     => $opt{base},
        content_type => 'text/html',
    }, $class;
    $self;
}

*req = \&request;

sub request { return $_[0]->{request} }
sub base_dir { return $_[0]->{base_dir} }
sub base { return $_[0]->{base} }

sub config {
    my $self = shift;
    if( defined $self->{config} ){
        return $self->{config};
    }else{
        my $ref = YAML::XS::LoadFile( $self->base_dir . ( lc( $self->{app} ) . '.yaml' ) );
        $self->{config} = $ref;
        return $ref;
    }
}

sub render {
    my ( $self, $tmpl, $args ) = @_;

    my $view;
    if( ref $tmpl eq 'HASH' ){
      my $class = "Noe::View::$tmpl->{as}";
      $class->require or die "Can't find viwe class: $@";
      $view = $class->new(%$args);
    }else{
      require Noe::View::TMT;
      $view = Noe::View::TMT->new(%$args);
    }

    return $view->render;

    $args->{req}  = $self->req;
    $args->{base} = $self->base;
    my $mt = Text::MicroTemplate::Extended->new(
        include_path  => [ $self->base_dir . 'tmpl' ],
        template_args => $args,
    );
    my $out = $mt->render($tmpl);
    return [
        200,
        [
            'Content-Type'   => $self->{content_type},
            'Content-Length' => length $out
        ],
        [$out]
    ];
}

sub redirect {
    my ( $self, $location ) = @_;
    return [ 302, [ 'Location' => $location ], [] ];
}

sub content_type {
    my ( $self, $content_type ) = @_;
    $self->{content_type} = $content_type || 'text/html';
}

1;

__END__
