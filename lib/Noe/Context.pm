package Noe::Context;
use Mouse;
use Encode;
use Template;
use Path::Class;
use YAML;

has 'request' => ( is => 'ro' , isa => 'Plack::Request', required => 1 );
has 'base_dir' => ( is => 'ro', isa => 'Path::Class::Dir', required => 1 );
has 'app' => ( is => 'ro', isa => 'Str', required => 1 );
has 'config' => ( is => 'ro', isa => 'HashRef|ArrayRef', lazy_build => 1 );

no Mouse;

*req = \&request;

sub _build_config {
    my $self = shift;
    my $ref = YAML::LoadFile( $self->base_dir->file( lc( $self->app ) . '.yaml' ) )
        or return {};
    return $ref;
}

sub render {
    my ( $self, $tmpl, $args ) = @_;
    my $config = { INCLUDE_PATH => [ $self->base_dir->subdir('tmpl') ], };
    if ( $tmpl =~ /\.tt2$/ ) {    #xxx
        $config->{WRAPPER} = 'wrapper';
    }
    my $template = Template->new($config);
    my $out;
    $args->{req}  = $self->req;
    $args->{base} = $self->req->base; #xxx
    $template->process( $tmpl, $args, \$out )
      || die $template->error(), "\n";
    $out = encode( 'utf8', $out );
    return [ 200, [ 'Content-Type' => 'text/html' ], [$out] ];
}

sub redirect {
    my ( $self, $location ) = @_;
    return [ 302, [ 'Location' => $location ], [''] ];
}

__PACKAGE__->meta->make_immutable;
1;

__END__
