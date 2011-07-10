use strict;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib/";
use MyApp;

my $app = MyApp->new;

done_testing;
