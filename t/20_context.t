use strict;
use warnings;
use Test::More;
use t::Utils qw( req );

my $req = req;
ok($req);
use_ok('Noe::Component');

{
    my $c = Noe::Component->new( request => $req );
    ok($c);
    my $res = $c->render( { as => 'JSON' }, { message => 'Hello' } );
    ok( $res, 'Render as JSON' );
    is_deeply $res,
      [
        '200', [ 'Content-Type' => 'application/json', 'Content-Length' => 19 ],
        ['{"message":"Hello"}']
      ],
      'Got JSON;';
}
{
    my $c = Noe::Component->new( request => $req, base_dir => 't/' );
    ok($c);
    my $res = $c->render( { as => 'TT', file => 'index.tt2' }, { message => 'Hello' } );
    ok( $res, 'Render as TT' );
    is_deeply $res,
      [
        '200', [ 'Content-Type' => 'text/html', 'Content-Length' => 5 ],
        ['Hello']
      ],
      'Got HTML by View::TT;';
}

done_testing;
