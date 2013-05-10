use strict;
use Test::More tests => 6;

use Algorithm::RankAggregate::BordaCount;

my @case_00 = (5, 4, 3, 2, 1);
my @weight_00 = (10);
my @ans_00 = (50, 40, 30, 20, 10);

my $bc_00 = Algorithm::RankAggregate::BordaCount->new(\@weight_00);
is_deeply($bc_00->get_weighted_count_list(\@case_00, 0), \@ans_00);

my @case_01 = (5, 4, 2, 1, 3);
my @weight_01 = (0.1);
my @ans_01 = (0.5, 0.4, 0.2, 0.1, 0.3);

my $bc_01 = Algorithm::RankAggregate::BordaCount->new(\@weight_01);
is_deeply($bc_01->get_weighted_count_list(\@case_01, 0), \@ans_01);

my @case_02 = (5, 1, 4, 3, 2);
my @weight_02 = (0.5);
my @ans_02 = (2.5, 0.5, 2, 1.5, 1);

my $bc_02 = Algorithm::RankAggregate::BordaCount->new(\@weight_02);
is_deeply($bc_02->get_weighted_count_list(\@case_02, 0), \@ans_02);

my @case_03 = (5, 1, 4, 3, 2);
my @weight_03 = (10, 0.5, 0.1);
my @ans_03_0 = (50, 10, 40, 30, 20);
my @ans_03_1 = (2.5, 0.5, 2, 1.5, 1);
my @ans_03_2 = (0.5, 0.1, 0.4, 0.3, 0.2);

my $bc_03 = Algorithm::RankAggregate::BordaCount->new(\@weight_03);
is_deeply($bc_03->get_weighted_count_list(\@case_03, 0), \@ans_03_0);
is_deeply($bc_03->get_weighted_count_list(\@case_03, 1), \@ans_03_1);
is_deeply($bc_03->get_weighted_count_list(\@case_03, 2), \@ans_03_2);
