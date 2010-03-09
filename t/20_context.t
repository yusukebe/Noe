use strict;
use warnings;
use Test::More;
use t::Utils qw( req );

my $req = req;
ok($req);
use_ok('Noe::Context');
my $c = Noe::Context->new( request => $req );
ok($c);
my $code = $c->render({ as => 'JSON' }, { message => 'Hello' });

done_testing;
