use strict;
use Test::More;
use Noe::Component;

my $c = Noe::Component->new;

my $body = 'Talk about Stars';

# Complex case
{
    my $res = $c->response( $body, 'text/plain', 'Content-Language' => 'en' );
    is_deeply(
        $res,
        [
            200,
            [
                'Content-Type'   => 'text/plain',
                'Content-Length' => length $body,
                'Content-Language' => 'en'
            ],
            [$body]
        ],
        'Complex case'
    );
}

done_testing;
