package Noe;
use Mouse;
our $VERSION = '0.01';
use Noe::Plack::Adapter;

sub plack_adapter {
    return '+Noe::Plack::Adapter';
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
