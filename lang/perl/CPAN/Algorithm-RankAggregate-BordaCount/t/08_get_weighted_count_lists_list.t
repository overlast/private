use strict;
use Test::More tests => 4;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (
    [1, 2, 3, 4, 5],
    [5, 4, 2, 1, 3],
    [5, 1, 4, 3, 2],
);
my @weight_01 = (0.4, 0.5, 0.1);

my @ans_00 = (
    [0.4, 0.8, 1.2, 1.6, 2],
    [2.5, 2, 1, 0.5, 1.5],
    [0.5, 0.1, 0.4, 0.3, 0.2],
);

my $bc = Algorithm::RankAggregate::BordaCount->new(\@weight_01);
my $result_00 = $bc->get_weighted_count_lists_list(\@case_00);
is($#case_00, $#ans_00);
for (my $i = 0; $i <= $#ans_00; $i++) {
    is_deeply($ans_00[$i], $result_00->[$i]);
}
