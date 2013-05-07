package Algorithm::RankAggregate::BordaCount;
use strict;
use warnings;
our $VERSION = '0.01';

sub get_ranked_lists {
    my ($this, $score_lists) = @_;
    my @ranked_lists = ();
    my %real_num_hash;
    my $i = 1;
    foreach my $real_num (@{$score_lists}) {
        $real_num_hash{$real_num} = $i;
        $i++;
    }
    foreach my $real_num (sort {$b <=> $a} keys %real_num_hash) {
        push @ranked_lists, $real_num_hash{$real_num};
    }
    return \@ranked_lists;
}

sub get_weighted_score_lists {
    my ($this, $score_lists, $row_num) = @_;
    my @weighted_score_lists = ();
    foreach my $real_num (@{$score_lists}) {
        my $weighted_real_num = $real_num * $this->{weight}->[$row_num];
        push @weighted_score_lists, $weighted_real_num;
    }
    return \@weighted_score_lists;
}

sub get_ranked_lists_lists {
    my ($this, $score_lists_lists, $top_k_num) = @_;
    my @lists_lists = ();
    my $i = 0;
    foreach my $score_lists (@{$score_lists_lists}) {
        if ((exists $this->{weight}) && (exists $this->{weight}->[$i])) {
            $score_lists = $this->get_weighted_score_lists($score_lists, $i);
        }
        $top_k_num = $#{$score_lists} unless ($top_k_num);
        my $ranked_lists = $this->get_ranked_lists($score_lists, $top_k_num);
        push @lists_lists, $ranked_lists;
        $i++;
    }
    return \@lists_lists;
}

sub check_is_valid_lists_lists {
    my ($this, $lists_lists) = @_;
    my $result = 1;
    my $colmun_count = -1;
    foreach my $lists (@{$lists_lists}) {
        if ($colmun_count > -1) {
            if ($colmun_count != $#{$lists}) {
                $result = 0;
                last;
            }
        }
        else {
            $colmun_count = $#{$lists};
        }
    }
    return $result;
}

sub aggregate {
    my ($this, $score_lists_lists, $top_k_num) = @_;
    my @result = ();
    return \@result unless ($this->check_is_valid_lists_lists($score_lists_lists));

    my $ranked_lists_lists = $this->get_ranked_lists_lists($score_lists_lists);
    for (my $item_num = 0; $item_num <= $#{$ranked_lists_lists->[0]}; $item_num++) {
        my $borda_count = 0;
        for (my $list_num = 0; $list_num <= $#{$ranked_lists_lists}; $list_num++) {
            my $score = $top_k_num - $ranked_lists_lists->[$list_num]->[$item_num] + 1;
            $borda_count += $score if ($score > 0);
        }
        push @result, $borda_count;
    }
    return \@result;
}

sub new {
    my ($class) = @_;
    my %hash;
    bless \%hash, $class;
}

1;
__END__

=head1 NAME

Algorithm::RankAggregate::BordaCount -

=head1 SYNOPSIS

  use Algorithm::RankAggregate::BordaCount;

=head1 DESCRIPTION

Algorithm::RankAggregate::BordaCount is

=head1 AUTHOR

Toshinori Sato E<lt>overlasting {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
