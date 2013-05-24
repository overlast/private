#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use autodie;

use Math::Random::OO::Normal;
use List::Util;

use YAML;

&main();

sub main {
    my $example_num = 100; # row
    my $column_num = 2; # column

    my $matrix = &make_matrix($example_num, $column_num);
    #print Dump $matrix;

    # in real case, we should use training data which are given a answer tag to each case by human.
    my $lavel_vec = &get_lavel($matrix);
    #print Dump $lavel_vec;

    my $weight_vec = &get_init_weight($column_num);
    #print Dump $weight_vec;

    my $iteration_num = &training($matrix, $weight_vec, $lavel_vec);
    print Dump $iteration_num;

    my $answer_vec = &predicting($matrix, $weight_vec);

    &evaluate($lavel_vec, $answer_vec);

    return;
}

sub evaluate {
    my ($lavel_vec, $answer_vec) = @_;
    my $all_num = 0;
    my $true_num = 0;
    my $false_num = 0;
    for (my $i = 0; $i <= $#$lavel_vec; $i++) {
        $all_num++;
        if ($lavel_vec->[$i] == $answer_vec->[$i]) {
            $true_num++;
        }
        else {
            $false_num++;
        }
    }
    my $rate = ($true_num / $all_num) * 100;
    print "all: $all_num, accuracy $rate % (true:$true_num vs false:$false_num)\n";
    return;
}

sub make_matrix {
    my ($row_num, $col_num) = @_;
    my $mron = Math::Random::OO::Normal->new(); # mean 0, stdev 1
    $mron->seed(0);
    my @matrix;
    for (my $i = 0; $i < $row_num; $i++) {
        my @vec = ();
        for (my $j = 0; $j < $col_num; $j++) {
            my $num = $mron->next();
            push @vec, $num;
        }
        push @matrix, \@vec;
    }
    return \@matrix;
}

# still 2 dim only
sub get_hyperplane {
    my ($x, $y) = @_;
    my  $h = 5 * $x + 3 * $y - 1; # 5x + 3y = 1
    return $h;
}

# still 2 dim only
sub get_lavel {
    my ($matrix) = @_;
    my @vec = ();
    foreach my $vec (@{$matrix}) {
       my $h = &get_hyperplane($vec->[0], $vec->[1]);
       my $t = ($h > 1) ? 1 : -1;
       push @vec, $t;
    }
    return \@vec;
}

sub get_init_weight {
    my ($dim_num) = @_;
    my @weight = ();
    for (my $i = 0; $i <= $dim_num; $i++) {
        push @weight, 0;
    }
    return \@weight;
}

sub predict {
    my ($example_vec, $weight_vec, $phi) = @_;
    my $predict = &get_sigh_plus(&get_multi_vec_vec($weight_vec, $phi));
    return $predict;
}

sub predicting {
    my ($matrix, $weight_vec) = @_;
    my @ans_vec = ();
    foreach my $example_vec (@{$matrix}) {
        my $phi = get_phi($example_vec);
        my $ans = &predict($example_vec, $weight_vec, $phi);
        push @ans_vec, $ans;
    }
    return \@ans_vec;
}

sub training {
    my ($matrix, $weight_vec, $lavel_vec) = @_;
    my $iteration_num = 0;
    while (1) {
        my @att_vec = List::Util::shuffle 0..$#{$matrix};
        my $error_num = 0;
        $iteration_num++;
        foreach my $att (@att_vec) {
            my $example_vec = $matrix->[$att];
            my $t = $lavel_vec->[$att];
            my $phi = get_phi($example_vec);
            my $ans = &predict($example_vec, $weight_vec, $phi);
            if ($ans != $t) {
                &update($weight_vec, $t, $phi);
                $error_num++;
            }
        }
        last if ($error_num == 0);
    }
    return $iteration_num;
}

sub update {
    my ($weight_vec, $t, $phi) = @_;
    for (my $i = 0; $i <= $#$weight_vec; $i++) {
        $weight_vec->[$i] += $t * $phi->[$i];
    }
    return;
}

sub get_multi_vec_vec {
    my ($vec_left, $vec_right) = @_;
    my @multi = ();
    for (my $i = 0; $i <= $#$vec_left; $i++) {
        my $m = ($vec_left->[$i] * $vec_right->[$i]);
        push @multi, $m;
    }
    return \@multi;
}

sub get_phi {
    my ($vec) = @_;
    my @phi = ();
    foreach my $num (@{$vec}) {
        push @phi, $num;
    }
    push @phi, 1;
    return \@phi;
}

sub get_sigh_plus {
    my ($vec) = @_;
    my $sum = 0;
    foreach my $num (@{$vec}) {
        $sum = $sum + $num;
    }
    my $result = -1;
    if ($sum >= 0) {
        $result = 1;
    }
    return $result;
}
