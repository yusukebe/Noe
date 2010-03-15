package Noe::Component;
use strict;
use warnings;
use YAML ();
use UNIVERSAL::require;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {
        request  => $opt{request},
        base_dir => $opt{base_dir} || '/',
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
        my $file = lc $self->{app};
        $file =~ s/::/_/g;
        my $ref = YAML::LoadFile( $self->base_dir . $file . '.yaml' );
        $self->{config} = $ref;
        return $ref;
    }
}

sub render {
    my ( $self, $tmpl, $args ) = @_;

    $args->{req}  = $self->req;
    $args->{base} = $self->base;

    my ($view, $class, $file );
    if ( ref $tmpl eq 'HASH' ) {
        $class = "Noe::View::$tmpl->{as}";
        $file = defined $tmpl->{file} ? $tmpl->{file} : '';
    }
    else {
        $file = $tmpl;
        $class = "Noe::View::TMT";
    }

    $class->require or die "Can't find viwe class: $@";
    $view = $class->new(
        include_path => [ $self->base_dir . 'tmpl' ],
        file         => $file,
        content_type => $self->{content_type},
    );
    return $view->render($args);
}

sub content_type {
    my ( $self, $content_type ) = @_;
    $self->{content_type} = $content_type || 'text/html';
}

sub handle {
    my ( $self, $code, $body, $type ) = @_;
    return $self->handle(500) unless $code;
    my $headers = $self->_headers( $body, $type );
    my $b = $body ? [$body] : [];
    return [ $code, $headers, $b ];
}

sub _headers {
    my ($self, $body, $type, @h) = @_;
    my $headers = [];
    push @$headers, 'Content-Type' => $type if $type;
    push @$headers, 'Content-Length' => length $body if $body;
    push @$headers, @h;
    return $headers;
}

sub redirect {
    my ( $self, $url, $code ) = @_;
    $code ||= 302;
    return [ $code, [ 'Location' => $url ], [] ];
}

sub response {
    my $self = shift;
    my ( $body, $type, @headers ) = @_;
    $type = $self->{content_type} if !$type && $self->{content_type};
    my $headers = $self->_headers( $body, $type, @headers );
    my $b = $body ? [$body] : [];
    return [ 200 , $headers, $b ];
}

1;

__END__
