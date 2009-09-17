package Noe::Context;
use Mouse;
use Template;
use Path::Class;

has 'request' => ( is => 'rw' , isa => 'Plack::Request', required => 1 );
has 'base_dir' => ( is => 'rw', isa => 'Path::Class::Dir', required => 1 );

sub render {
    my ( $self, $tmpl, $args ) = @_;
    my $config = { INCLUDE_PATH => [ $self->base_dir->subdir('tmpl') ], };
    my $template = Template->new($config);
    my $out;
    $args->{base} = $self->request->base;
    $template->process( $tmpl, $args, \$out )
        || die $template->error(), "\n";
    return [ 200, [ 'Content-Type' => 'text/html' ], [$out] ];
}

1;

__END__
