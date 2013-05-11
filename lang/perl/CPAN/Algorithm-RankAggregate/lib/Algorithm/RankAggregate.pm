package Algorithm::RankAggregate;

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

Algorithm::RankAggregate - Base class of Pure Perl implementation of Rank Aggregate Algorithms

=head1 SYNOPSIS

    use base qw/Algorithm::RankAggregate/;

=head1 DESCRIPTION

Algorithm::RankAggregate is base class of Pure Perl implementation of the some Rank Aggregate Algorithms.

=head1 AUTHOR

Toshinori Sato (@overlast) E<lt>overlasting {at} gmail.comE<gt>

=head1 SEE ALSO

https://github.com/overlast/private/tree/master/lang/perl/CPAN

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
