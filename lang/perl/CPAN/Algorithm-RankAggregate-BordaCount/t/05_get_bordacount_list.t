use strict;
use Test::More tests => 9;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (1, 2, 3, 4, 5);
my @ans_00 =  (5, 4, 3, 2, 1);

my @case_01 = (5, 4, 2, 1, 3);
my @ans_01 =  (1, 2, 4, 5, 3);

my @case_02 = (5, 1, 4, 3, 2);
my @ans_02 =   (1, 5, 2, 3, 4);

my @case_03 = (5, 1, 4, 3, 2);
my @ans_03_0 = (0, 0, 0, 0, 0);
my @ans_03_1 = (0, 1, 0, 0, 0);
my @ans_03_2 = (0, 2, 0, 0, 1);
my @ans_03_3 = (0, 3, 0, 1, 2);
my @ans_03_4 = (0, 4, 1, 2, 3);
my @ans_03_5 = (1, 5, 2, 3, 4);

my $bc = Algorithm::RankAggregate::BordaCount->new();

is_deeply($bc->get_bordacount_list(\@case_00), \@ans_00);
is_deeply($bc->get_bordacount_list(\@case_01), \@ans_01);
is_deeply($bc->get_bordacount_list(\@case_02), \@ans_02);
is_deeply($bc->get_bordacount_list(\@case_03, 0), \@ans_03_0);
is_deeply($bc->get_bordacount_list(\@case_03, 1), \@ans_03_1);
is_deeply($bc->get_bordacount_list(\@case_03, 2), \@ans_03_2);
is_deeply($bc->get_bordacount_list(\@case_03, 3), \@ans_03_3);
is_deeply($bc->get_bordacount_list(\@case_03, 4), \@ans_03_4);
is_deeply($bc->get_bordacount_list(\@case_03, 5), \@ans_03_5);
