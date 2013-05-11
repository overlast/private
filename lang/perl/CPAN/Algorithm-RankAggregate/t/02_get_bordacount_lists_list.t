use strict;
use Test::More tests => 8;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (
    [1, 2, 3, 4, 5],
    [5, 4, 2, 1, 3],
    [5, 1, 4, 3, 2],
);

my @ans_00 = (
    [5, 4, 3, 2, 1],
    [1, 2, 4, 5, 3],
    [1, 5, 2, 3, 4],
);

my @case_01 = (
    [1, 2, 3, 4, 5],
    [5, 4, 2, 1, 3],
    [5, 1, 4, 3, 2],
);
my $top_k_num_01 = 3;
my @ans_01 = (
    [3, 2, 1, 0, 0],
    [0, 0, 2, 3, 1],
    [0, 3, 0, 1, 2],
);

my $bc = Algorithm::RankAggregate::BordaCount->new();

my $result_00 = $bc->get_bordacount_lists_list(\@case_00);
is($#case_00, $#ans_00);
for (my $i = 0; $i <= $#ans_00; $i++) {
    is_deeply($ans_00[$i], $result_00->[$i]);
}

my $result_01 = $bc->get_bordacount_lists_list(\@case_01, $top_k_num_01);
is($#case_01, $#ans_01);
for (my $i = 0; $i <= $#ans_01; $i++) {
    is_deeply($ans_01[$i], $result_01->[$i]);
}
