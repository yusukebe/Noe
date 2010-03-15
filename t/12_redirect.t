use strict;
use Test::More;
use Noe::Component;

my $c = Noe::Component->new;

my $url = 'http://search.cpan.org';
my $res = $c->redirect( $url );
is_deeply( $res, [302,[ 'Location' => $url ],[] ], 'Redirect' );
done_testing;
