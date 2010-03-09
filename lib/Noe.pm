package Noe;
use strict;
our $VERSION = '0.0';
use URI;
use Noe::Context;
use Plack::Request;
use UNIVERSAL::require;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {
        app  => $class,
        root => $opt{root} || 'root',
    }, $class;
    $self;
}

sub base_dir {
    my $self = shift;
    # tokuhirom hacks
    my $p    = $self->{app} . ".pm";
    $p =~ s!::!/!g;
    my $path = $INC{$p};
    $path =~ s!(?:blib/)?lib/$p$!\.!;
    return "$path/";
}

sub psgi_handler {
    my $self = shift;

    return sub {
        my $env = shift;
        if( defined $env->{HTTP_X_FORWARDED_HOST} && $env->{HTTP_X_FORWARDED_HOST} != 80 ){
            $env->{SERVER_PORT} = $env->{HTTP_X_FORWARDED_PORT};
        }
        my $req  = Plack::Request->new($env);

        my $context = Noe::Context->new(
            request  => $req,
            base_dir => $self->base_dir(),
            app      => $self->{app},
            base     => $self->base_uri($env),
        );

        my $app        = $self->{app};
        my $dispatcher = "${app}::Dispatcher";
        $dispatcher->require or die "Can't find dispatcher : $@";
        my $rule = $dispatcher->match($req);
        my $controller = "${app}::Controller::$rule->{controller}";
        eval { $controller->use };
        if ($@) { return $self->handle_404 }
        my $method = $rule->{action} or return $self->handle_404;
        my $code;
        eval { $code = $controller->$method($context, $rule->{args}) };
        if( $code ){
            return $code;
        }else{
            warn $@;
            return $self->handle_500;
        }
    }
}

sub base_uri {
    my ( $self, $env ) = @_;
    my $base_path;
    $base_path = $env->{SCRIPT_NAME} || '/';
    my $base = URI->new;
    $base->scheme( $env->{'psgi.url_scheme'} );
    $base->host($env->{HTTP_HOST} || $env->{SERVER_NAME});
    $base->port($env->{SERVER_PORT});
    $base->path($base_path);
    return $base;
}

sub handle_404 {
    my $self = shift;
    return [
        404, [ "Content-Type" => "text/plain", "Content-Length" => 13 ],
        ["404 Not Found"]
    ];
}

sub handle_500 {
    my $self = shift;
    return [
        500, [ "Content-Type" => "text/plain", "Content-Length" => 21 ],
        ["Internal Server Error"]
    ];
}

1;

__END__

=head1 NAME

Noe - Isurugi Noe in true tears.

=head1 SYNOPSIS

  # MyApp.pm
  package MyApp;
  use base 'Noe';
  1;

  # myapp.psgi
  use MyApp;
  my $app = MyApp->new();
  $app->psgi_handler;

=head1 DESCRIPTION

Noe is Minimal Web Application Framework based on Plack/PSGI.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

Plack/PSGI

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
