package Noe::Context;
use Mouse;
use Encode;
use Text::MicroTemplate::Extended;
use URI;
use YAML::XS;

has 'request'  => ( is => 'ro', isa => 'Plack::Request',   required => 1 );
has 'base_dir' => ( is => 'ro', isa => 'Str', required => 1 );
has 'app'      => ( is => 'ro', isa => 'Str',              required => 1 );
has 'config' => ( is => 'ro', isa => 'HashRef|ArrayRef', lazy_build => 1 );
has 'base' => ( is => 'ro', isa => 'URI', required => 1 );

no Mouse;

*req = \&request;

sub _build_config {
    my $self = shift;
    my $ref = YAML::XS::LoadFile( $self->base_dir . ( lc( $self->app ) . '.yaml' ) )
        or return {};
    return $ref;
}

sub render {
    my ( $self, $tmpl, $args ) = @_;
    $args->{req}  = $self->req;
    $args->{base} = $self->base;
    my $mt = Text::MicroTemplate::Extended->new(
        include_path  => [ $self->base_dir . 'tmpl' ],
        template_args => $args,
    );
    my $out = $mt->render( $tmpl );
    $out = encode( 'utf8', $out );
    return [ 200, [ 'Content-Type' => 'text/html', 'Content-Length' => length $out ], [$out] ];
}

sub redirect {
    my ( $self, $location ) = @_;
    warn $location;
    return [ 302, [ 'Location' => $location ], [] ];
}

__PACKAGE__->meta->make_immutable;
1;

__END__
