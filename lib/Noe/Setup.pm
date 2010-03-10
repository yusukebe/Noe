package Noe::Setup;
use strict;
use warnings;
use Module::Setup;

sub run {
    my ($self, $app_name) = @_;
    my $options = { 'flavor_class' => 'Noe::Setup::Flavor' };
    my $pmsetup = Module::Setup->new(
        options => $options,
        argv    => [ $app_name ],
    );
    $pmsetup->run;
}

1;
