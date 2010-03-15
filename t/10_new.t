use strict;
use Test::More;

use_ok('Hitagi');
my $hitagi = Hitagi->new;
ok( $hitagi, 'Make Instance' );

done_testing;
