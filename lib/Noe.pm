package Noe;
use Mouse;
our $VERSION = '0.01';
use Noe::Context;
use Plack::Request;
use File::Spec;
use File::Basename;
use Path::Class;
use MIME::Types;
use UNIVERSAL::require;

has 'app' => ( is => 'ro', isa => 'Str', required => 1 );
has 'root' => ( is => 'rw', isa => 'Str', required => 1, default => 'root' );
has 'mime_types' => (
    is      => 'ro',
    isa     => 'MIME::Types',
    lazy    => 1,
    default => sub {
        my $mime_types = MIME::Types->new( only_complete => 1 );
        $mime_types->create_type_index;
        $mime_types;
    },
);
has 'base_dir' => (
    is         => 'rw',
    isa        => 'Path::Class::Dir',
    lazy_build => 1,
);

sub _build_base_dir {
    my $self = shift;
    my $p    = $self->app() . ".pm";
    $p =~ s!::!/!g;
    my $path = $INC{$p};
    $path =~ s!lib/$p$!\.!;
    dir($path);
}

sub BUILDARGS {
    my ($class) = shift;
    return { app => $class };
}

sub psgi_handler {
    my $self = shift;
    return sub {
        my $req     = Plack::Request->new(shift);
        my $context = Noe::Context->new(
            request  => $req,
            base_dir => $self->base_dir,
            app      => $self->app
        );
        my $base = $req->base;

        # serve static file
        my $regex = "(?:png|jpg|gif|css|txt)";
        if ( $req->uri =~ /$base(.+\.$regex)/ ) {
            return $self->handle_static($1);
        }

        my $app        = $self->app;
        my $dispatcher = "${app}::Dispatcher";
        $dispatcher->require or die "can't find dispatcher : $@";
        my $rule = $dispatcher->match($req);
        no warnings;
        my $controller = "${app}::Controller::$rule->{controller}";
        use warnings;
        $controller->require;
        my $method = $rule->{action} or return $self->handle_404;
        if( my $code = $controller->$method($context) ){
            return $code;
        }else{
            return $self->handle_404;
        }
    }
}

sub handle_static {
    my ( $self, $filename ) = @_;
    my $path =
      $self->base_dir->file( $self->root,
        File::Spec::Unix->splitpath($filename) );
    open my $fh, "<", $path or return $self->handle_404;
    my $content_type = 'text/plain';
    if ( $filename =~ /.*\.(\S{1,})$/xms ) {
        $content_type = $self->mime_types->mimeTypeOf($1)->type;
    }
    return [
        200,
        [
            "Content-Type"   => $content_type,
            "X-Sendfile"     => $path,
            "Content-Length" => -s $fh
        ],
        $fh
    ];
}

sub handle_404 {
    my $self = shift;
    return [
        404, [ "Content-Type" => "text/plain", "Content-Length" => 13 ],
        ["404 not found"]
    ];
}

1;
__END__

=head1 NAME

Noe -

=head1 SYNOPSIS

  use Noe;

=head1 DESCRIPTION

Noe is

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
