package Noe::Controller;
use Mouse::Role;
use Template;
use Path::Class;

sub render {
    my ( $tmpl, %args ) = @_;
    my $config = { INCLUDE_PATH => [ Noe::c->base_dir->subdir('tmpl') ], };
    my $template = Template->new($config);
    my $out;
    $template->process( 'index.tt2', \%args, \$out )
      || die $template->error(), "\n";
    return [ 200, [ 'Content-Type' => 'text/html' ], [ $out ], ];
}

1;

__END__
