package Algorithm::RankAggregate::BordaCount;

use strict;
use warnings;
our $VERSION = '0.0.1';

sub get_ranked_list {
    my ($this, $score_list) = @_;
    my @ranked_list = ();
    my %real_num_hash;
    my $i = 1;
    foreach my $real_num (@{$score_list}) {
        $real_num_hash{$i} = $real_num;
        $i++;
    }
    my $current_num = 0;
    my $same_rank = 0;
    my $j = 0;
    foreach my $k (sort {$real_num_hash{$b} <=> $real_num_hash{$a}} keys %real_num_hash) {
        if (($current_num) && ($current_num == $real_num_hash{$k})) {
            $same_rank++;
        }
        else {
            $j = $j + $same_rank + 1;
            $same_rank = 0;
            $current_num = $real_num_hash{$k};
        }
        $ranked_list[$k - 1] = $j;
    }
    return \@ranked_list;
}

sub get_ranked_lists_list {
    my ($this, $score_lists_list) = @_;
    my @lists_list = ();
    my $i = 0;
    foreach my $score_list (@{$score_lists_list}) {
        my $ranked_list = $this->get_ranked_list($score_list);
        push @lists_list, $ranked_list;
        $i++;
    }
    return \@lists_list;
}

sub validate_lists_list {
    my ($this, $lists_list) = @_;
    my $result = 1;
    my $colmun_count = -1;
    foreach my $list (@{$lists_list}) {
        if ($colmun_count > -1) {
            if ($colmun_count != $#{$list}) {
                $result = 0;
                last;
            }
        }
        else {
            $colmun_count = $#{$list};
        }
    }
    return $result;
}

sub get_bordacount_list {
    my ($this, $ranked_list, $top_k_num) = @_;
    my @bordacount_list;
    $top_k_num = $#{$ranked_list} + 1 unless (defined $top_k_num);
    foreach my $rank_num (@{$ranked_list}) {
        my $score = 0;
        if (($rank_num > 0) && ($rank_num <= $top_k_num)) {
            $score = $top_k_num - $rank_num + 1;
        }
        push @bordacount_list, $score;
    }
    return \@bordacount_list;
}

sub get_bordacount_lists_list {
    my ($this, $ranked_lists_list, $top_k_num) = @_;
    my @lists_list = ();
    my $i = 0;
    foreach my $rank_list (@{$ranked_lists_list}) {
        my $bordacount_list = $this->get_bordacount_list($rank_list, $top_k_num);
        push @lists_list, $bordacount_list;
    }
    return \@lists_list;
}

sub get_weighted_count_list {
    my ($this, $count_list, $row_num) = @_;
    my @weighted_count_list = ();
    foreach my $count_num (@{$count_list}) {
        my $weighted_count_num = $count_num * $this->{weight}->[$row_num];
        push @weighted_count_list, $weighted_count_num;
    }
    return \@weighted_count_list;
}

sub get_weighted_count_lists_list {
    my ($this, $count_lists_list) = @_;
    my @lists_list = ();
    my $i = 0;
    foreach my $count_list (@{$count_lists_list}) {
        my $weighted_count_list = $this->get_weighted_count_list($count_list, $i);
        push @lists_list, $weighted_count_list;
        $i++;
    }
    return \@lists_list;
}

sub get_bordacount_result {
    my ($this, $bordacount_lists_list) = @_;
    my @lists_list = ();
    for (my $i = 0; $i <= $#{$bordacount_lists_list->[0]}; $i++) {
        my $result = 0;
        for (my $j = 0; $j <= $#{$bordacount_lists_list}; $j++) {
            $result = $result + $bordacount_lists_list->[$j]->[$i];
        }
        push @lists_list, $result;
    }
    return \@lists_list;
}

sub aggregate {
    my ($this, $score_lists_lists, $top_k_num) = @_;
    my @result = ();
    return \@result unless ($this->validate_lists_list($score_lists_lists));
    my $ranked_lists_list = $this->get_ranked_lists_list($score_lists_lists);
    my $bordacount_lists_list = $this->get_bordacount_lists_list($ranked_lists_list, $top_k_num);
    if ((exists $this->{weight}) && (exists $this->{weight}->[0])) {
        $bordacount_lists_list = $this->get_weighted_count_lists_list($bordacount_lists_list);
    }
    @result = @{$this->get_bordacount_result($bordacount_lists_list)} if (@{$bordacount_lists_list});
    return \@result;
}

sub new {
    my ($class, $weight_list) = @_;
    my %hash = (
        'weight' => $weight_list,
    );
    bless \%hash, $class;
}

1;
__END__

=head1 NAME

Algorithm::RankAggregate::BordaCount - Pure Perl implementation of Borda count

=head1 SYNOPSIS

    use Algorithm::RankAggregate::BordaCount;

    my @case = (
        [-26.8,  -3.8, -11.2, -9.4, -2.7],
        [-24.8,  18.2, -8.0,  -3.4, 18.0],
        [-17.7,  13.0, -2.4,  -5.7, 12.9],
    );

    my $bc = Algorithm::RankAggregate::BordaCount->new();

    # give point to attribute which is ranked higher than 4
    my @result = @{$bc->aggregate(\@case, 4)};

    # in this case, @result = (0,11,4,5,10)

=head1 DESCRIPTION

Algorithm::RankAggregate::BordaCount is Pure Perl implementation of Borda count.
You may read http://en.wikipedia.org/wiki/Borda_count.

=head1 EXPORTED FUNCTIONS

=head2 new()
You can get the instance of this module in following way.

    my $bc = Algorithm::RankAggregate::BordaCount->new();

=head2 new(\@array)
If you want to think of multi voters, you can get the instance of this module in following way.

    my @voters = (42, 26, 15, 17);
    my $bc = Algorithm::RankAggregate::BordaCount->new(\@voters);

If you want to use weighted borda count, you can get the instance of this module in following way.

    my @weights = (0.4, 0.3, 0.2, 0.1);
    my $bc = Algorithm::RankAggregate::BordaCount->new(\@weights);

=head2 aggregate(\@array_of_array)
In first, you should make a array of array which make from real value.

    my @case = (
         [-26.8,  -3.8, -11.2, -9.4, -2.7],
         [-24.8,  18.2, -8.0,  -3.4, 18.0],
         [-17.7,  13.0, -2.4,  -5.7, 12.9],
    );

And you can get borda counts in following way.

    my @result = @{$bc->aggregate(\@case)};

=head2 aggregate(\@array_of_array, $positive_int_value, $rank_higher_than)
If you want to give the point to candidate which is ranked higher than N, you can get borda counts in following way.

    my @result = @{$bc->aggregate(\@case, N)};

By using this parameter, you can give "N - rank + 1" point to candidate.

=head1 Example
This is example to represent "how to use Algorithm::RankAggregate::BordaCount".

    use Algorithm::RankAggregate::BordaCount;

    # http://en.wikipedia.org/wiki/Borda_count
    # each array of array are (Memphis, Nashville, Chattanooga, Knoxville)
    my @case = (
        [4, 3, 2, 1],
        [1, 4, 3, 2],
        [1, 2, 4, 3],
        [1, 2, 3, 4],
    );
    my @voters = (42,26,15,17);
    my $bc = Algorithm::RankAggregate::BordaCount->new(\@voters);
    my @result = @{$bc->aggregate(\@case_00, 3);

    # in this case, @result = (126, 194, 173, 107)

=head1 AUTHOR

Toshinori Sato (@overlast) E<lt>overlasting {at} gmail.comE<gt>

=head1 SEE ALSO

https://github.com/overlast/private/tree/master/lang/perl/CPAN

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
