use strict;
use Test::More tests => 4;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (
    [279.8, 188.8, 84.8, 41.8,  20.1],
    [-24.8, -18.2, -8.0, -3.4, -18.0],
    [-17.7,  13.0, -5.7, -2.4,  12.9],
);

my @case_01 = (
    [279.8, 188.8, 84.8, 41.8,  20.1, 20.1],
    [-24.8, -18.2, -8.0, -3.4, -18.0],
    [-17.7,  13.0, -5.7, -2.4,  12.9],
);

my @case_02 = (
    [279.8, 188.8, 84.8, 41.8,  20.1],
    [-24.8, -18.2, -8.0, -3.4, -18.0, -18.0],
    [-17.7,  13.0, -5.7, -2.4,  12.9],
);

my @case_03 = (
    [279.8, 188.8, 84.8, 41.8,  20.1],
    [-24.8, -18.2, -8.0, -3.4, -18.0],
    [-17.7,  13.0, -5.7, -2.4,  12.9, 12.9],
);

my $bc = Algorithm::RankAggregate::BordaCount->new();
is($bc->validate_lists_list(\@case_00), 1);
is($bc->validate_lists_list(\@case_01), 0);
is($bc->validate_lists_list(\@case_02), 0);
is($bc->validate_lists_list(\@case_03), 0);
