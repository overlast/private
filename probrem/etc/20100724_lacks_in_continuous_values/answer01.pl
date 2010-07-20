#!/usr/bin/env perl

use strict;
use warnings;
use YAML;

sub get_rack_number_arr_ref {
    my ($arr_ref) = @_;
    my @res_arr = ();
    if ($#{$arr_ref} == 0) {
	@res_arr = @{$arr_ref};
    }
    for (my $i = 0; $i < $#{$arr_ref}; $i++) {
	my $rack_num = ($arr_ref->[$i + 1] - 1) - $arr_ref->[$i];
	if ($rack_num == 0) {
	    next;
	}
	else {
	    for (my $j = 1; $j <= $rack_num; $j++) {
		push @res_arr, ($arr_ref->[$i] + $j);
	    }
	}
    }
    return \@res_arr;
}

sub fetch {
    my ($ex) = @_;
    my @ex_arr = sort { $a <=> $b } split / /, $ex;
    my $res_arr_ref = &get_rack_number_arr_ref(\@ex_arr);
    print Dump $res_arr_ref;
    return;
}

my $ex1 = "1 2 3 5 6 8 9 10 13 14";
&fetch($ex1);
my $ex2 = "1 3 6 10 15 21";
&fetch($ex2);
