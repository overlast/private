use strict;
use Test::More tests => 1;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (
    [-26.8,  -3.8, -11.2, -9.4, -2.7],
    [-24.8,  18.2, -8.0,  -3.4, 18.0],
    [-17.7,  13.0, -2.4,  -5.7, 12.9],
);
my @ans_00 = (0,11,4,5,10);

my $bc = Algorithm::RankAggregate::BordaCount->new();

my $result_00 = $bc->aggregate(\@case_00, 4);
is_deeply(\@ans_00, $result_00);
