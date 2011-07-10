package Noe::Util;
use strict;
use warnings;
use base qw/Exporter/;

our @EXPORT_OK = qw/dumper/;

sub dumper {
    my ( $self, $data ) = @_;
    require YAML;
    return Dump $data;
}

1;
