package Noe;
use strict;
our $VERSION = '0.01';
use Noe::Component;
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

*handler = \&psgi_handler;

sub psgi_handler {
    my $self = shift;

    return sub {
        my $env = shift;

        my $req  = Plack::Request->new($env);

        my $c = Noe::Component->new(
            request  => $req,
            base_dir => $self->base_dir,
            app      => $self->{app},
            base     => $req->base,
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
        eval { $code = $controller->$method($c, $rule->{args}) };
        if( $code ){
            return $code;
        }else{
            warn $@;
            return $self->handle_500;
        }
    }
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

Noe - true tears on web application framework.

=head1 SYNOPSIS

in MyApp.pm

  package MyApp;
  use base 'Noe';
  1;

in myapp.psgi

  use MyApp;
  my $app = MyApp->new();
  $app->handler;

=head1 DESCRIPTION

Noe is Minimal Web Application Framework based on Plack/PSGI.

=head2 HOW TO START

Run setup command with your module name.

  $ noe-setup MyApp::Web

Generated files.

  $ noe-setup MyApp::Web
  Writing ./MyApp-Web/tmpl/index.mt
  Writing ./MyApp-Web/myapp_web.yaml
  Writing ./MyApp-Web/root/static/css/ie.css
  Writing ./MyApp-Web/root/static/css/print.css
  Writing ./MyApp-Web/root/static/css/screen.css
  Writing ./MyApp-Web/root/static/css/LICENSE
  Writing ./MyApp-Web/lib/MyApp/Web/Controller/Root.pm
  Writing ./MyApp-Web/lib/MyApp/Web/Dispatcher.pm
  Writing ./MyApp-Web/lib/MyApp/Web.pm
  Writing ./MyApp-Web/myapp_web.psgi

Then run with plackup

  $ plackup myapp_web.psgi

=head2 MAKE YOUR APPLICATION

=head3 Dispatcher

Noe::Dispatcher is HTTPx::Dispatcher based. Write rules on your dispatcher class.

  package MyApp::Web::Dispatcher;
  use Noe::Dispatcher;

  connect ''         => { controller => 'Root', action => 'index' };
  connect 'hi'       => { controller => 'Root', action => 'hi' };
  connect 'json'     => { controller => 'JSON', action => 'index' };

  1;

=head3 Controller

You can write simply.

  package MyApp::Web::Controller::Root;

  sub index {
      my ( $self, $c  ) = @_;
      $c->render('index', { message => $c->config->{message} } );
  }

  sub hi {
      my ( $self, $c ) = @_;
      my $name = $c->req->param('name') || 'no name';
      $c->render('hi', { name => $name } );
  }

=head3 View

Default view template engine is 'Text::MicroTemplate::Extended'.
Write index.mt and hi.mt in "tmpl" directory.

  <h2>Message from Config</h2>
  <p><?= $message ?></p>
  <h2>GET Request</h2>
  <form action="/hi">
  <input type="text" name="name" />
  <input type="submit">
  </form>

Template-Toolkit and JSON views are available now.
If you return as JSON write controller like below.

  package MyApp::Web::Controller::JSON;

  sub index {
      my ( $self, $c ) = @_;
      $c->render( { as => 'JSON' }, { message => $c->config->{message} } );
  }

  1;

=head1 NOT YET

Session is not supported yet.

=head1 WHAT IS "Noe"

The character of my favorite TV animation "true tears".
She said

  I've presented my tears to my lover...

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

Plack/PSGI

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
