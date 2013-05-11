use strict;
use Test::More tests => 4;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (279.8, 188.8, 84.8, 41.8,  20.1);
my @ans_00 = (1, 2, 3, 4, 5);

my @case_01 = (-24.8, -18.2, -8.0, -3.4, -18.0);
my @ans_01 = (5, 4, 2, 1, 3);

my @case_02 = (-17.7,  13.0, -5.7, -2.4,  12.9);
my @ans_02 = (5, 1, 4, 3, 2);

my @case_03 = (-17.7,  13.0, -2.4, -2.4,  12.9);
my @ans_03 = (5, 1, 3, 3, 2);


my $bc = Algorithm::RankAggregate::BordaCount->new();

is_deeply($bc->get_ranked_list(\@case_00), \@ans_00);
is_deeply($bc->get_ranked_list(\@case_01), \@ans_01);
is_deeply($bc->get_ranked_list(\@case_02), \@ans_02);
is_deeply($bc->get_ranked_list(\@case_03), \@ans_03);
