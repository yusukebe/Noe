use strict;
use warnings;
use Test::More;
use t::Utils qw( req );

my $req = req;
ok($req);
use_ok('Noe::Context');
my $c = Noe::Context->new( request => $req );
ok($c);
my $res = $c->render({ as => 'JSON' }, { message => 'Hello' });
ok($res,'Render as JSON');
is_deeply $res,
  [
    '200', [ 'Content-Type' => 'application/json', 'Content-Length' => 19 ],
    ['{"message":"Hello"}']
  ] , 'Got JSON;' ;
done_testing;
