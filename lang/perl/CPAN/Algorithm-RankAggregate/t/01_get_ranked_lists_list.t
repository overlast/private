use strict;
use Test::More tests => 4;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (
    [279.8, 188.8, 84.8, 41.8,  20.1],
    [-24.8, -18.2, -8.0, -3.4, -18.0],
    [-17.7,  13.0, -5.7, -2.4,  12.9],
);

my @ans_00 = (
    [1, 2, 3, 4, 5],
    [5, 4, 2, 1, 3],
    [5, 1, 4, 3, 2],
);

my $bc = Algorithm::RankAggregate::BordaCount->new();

my $result_00 = $bc->get_ranked_lists_list(\@case_00);
is($#case_00, $#ans_00);
for (my $i = 0; $i <= $#ans_00; $i++) {
    is_deeply($ans_00[$i], $result_00->[$i]);
}
