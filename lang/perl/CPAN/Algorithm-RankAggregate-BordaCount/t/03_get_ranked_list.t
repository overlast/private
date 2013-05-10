use strict;
use Test::More tests => 10;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (279.8, 188.8, 84.8, 41.8,  20.1);
my @ans_00 = (1, 2, 3, 4, 5);

my @case_01 = (-24.8, -18.2, -8.0, -3.4, -18.0);
my @ans_01 = (5, 4, 2, 1, 3);

my @case_02 = (-17.7,  13.0, -5.7, -2.4,  12.9);
my @ans_02 = (5, 1, 4, 3, 2);

my @case_03 = (-17.7,  13.0, -5.7, -2.4,  12.9);
my @ans_03_0 = (-1,-1, -1, -1, -1);
my @ans_03_1 = (-1, 1, -1, -1, -1);
my @ans_03_2 = (-1, 1, -1, -1,  2);
my @ans_03_3 = (-1, 1, -1,  3,  2);
my @ans_03_4 = (-1, 1,  4,  3,  2);
my @ans_03_5 = ( 5, 1,  4,  3,  2);

my $bc = Algorithm::RankAggregate::BordaCount->new();

is_deeply($bc->get_ranked_list(\@case_00), \@ans_00);
is_deeply($bc->get_ranked_list(\@case_01), \@ans_01);
is_deeply($bc->get_ranked_list(\@case_02), \@ans_02);
is_deeply($bc->get_ranked_list(\@case_03, 0), \@ans_03_0);
is_deeply($bc->get_ranked_list(\@case_03, 1), \@ans_03_1);
is_deeply($bc->get_ranked_list(\@case_03, 2), \@ans_03_2);
is_deeply($bc->get_ranked_list(\@case_03, 3), \@ans_03_3);
is_deeply($bc->get_ranked_list(\@case_03, 4), \@ans_03_4);
is_deeply($bc->get_ranked_list(\@case_03, 5), \@ans_03_5);

my @case_04 = (-17.7,  13.0, -2.4, -2.4,  12.9);
my @ans_04 = (5, 1, 3, 3, 2);
is_deeply($bc->get_ranked_list(\@case_04), \@ans_04);
