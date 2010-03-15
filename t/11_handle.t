use strict;
use Test::More;
use Noe::Component;

my $c = Noe::Component->new;

# Simple case
{
    my $res = $c->handle(400);
    is_deeply( $res, [ 400, [], [] ], 'Simple case' );
}

# Complex case
{
    my $res = $c->handle( 500, 'Internal Server Error', 'text/plain' );
    is_deeply(
        $res,
        [
            500,
            [
                'Content-Type'   => 'text/plain',
                'Content-Length' => 21,
            ],
            ['Internal Server Error']
        ],
        'Complex case'
    );
}

# Error case
{
    my $res = $c->handle;
    is_deeply( $res, [ 500, [], [] ], 'Error case' );
}

done_testing;
