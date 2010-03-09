package Noe::Server;
use strict;
use warnings;
use Plack::Runner;
use Plack::Middleware::Static;
use Plack::Middleware::Debug;
use Plack::Middleware::Conditional;
use Plack::Middleware::AccessLog;
use Path::Class qw( dir );
use UNIVERSAL::require;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {}, $class;
    my $target_class = $self->find_class;
    die "Can't find Noe based Class\n" unless $target_class;
    $self->{class} = $target_class;
    $self;
}

sub run {
    my $self = shift;
    my $app;
    eval { $app = $self->{class}->new->psgi_handler };
    $app = Plack::Middleware::Static->wrap(
        $app,
        path => qr{^/static},
        root => './root/'
    );
#    $app = Plack::Middleware::Debug->wrap($app);
    $app = Plack::Middleware::Conditional->wrap(
        $app,
        condition =>
          sub { my $env = shift; !( $env->{PATH_INFO} =~ /^\/static/ ) },
        builder =>
          sub { Plack::Middleware::AccessLog->wrap( $app ) },
    );
    $ENV{PLACK_ENV} = 'test';
    my $runner = Plack::Runner->new;
    $runner->parse_options(@ARGV);
    $runner->run($app);
}

#XXX
sub find_class {
    my $self = shift;
    my $dir  = dir('./lib');
    push @INC, $dir->absolute->stringify;
    for ( $dir->children ) {
        if ( $_ =~ /\.pm$/ ) {
            my $class = $_;
            $class =~ s/\/?lib\/?(\w+)\.pm$/$1/;
            $class =~ s/\//::/;
            eval { $class->use; "Noe"->use; };
            next if $@;
            return $class;
        }
    }
    return;
}

1;

__END__

=head1 NAME

Noe::Server - A Debug Server for Noe.

=head1 SYNOPSIS

=head1 DESCRIPTION

Noe::Server is 

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
