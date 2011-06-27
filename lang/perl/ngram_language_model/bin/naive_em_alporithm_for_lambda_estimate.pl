#!/usr/bin/env perl

# usage: ./bin/naive_em_alporithm_for_lambda_estimate.pl ./sample/13tokyo.tsv.shuf.s01.uni ./sample/13tokyo.tsv.shuf.s02.uni ./sample/13tokyo.tsv.shuf.s03.uni 1 # for unigram
# usage: ./bin/naive_em_alporithm_for_lambda_estimate.pl ./sample/13tokyo.tsv.shuf.s01.uni ./sample/13tokyo.tsv.shuf.s02.uni ./sample/13tokyo.tsv.shuf.s03.uni 2  for bigram

use strict;
use warnings;
use utf8;
use Encode;

my ($IN1, $IN2, $IN3);
my $model_file1 = $ARGV[0];
my $model_file2 = $ARGV[1];
my $input_file = $ARGV[2];
my $ngram_num = $ARGV[3];
unless ($model_file1) { exit; }
unless ($model_file2) { exit; }
unless ($input_file) { exit; }
unless ($ngram_num) { $ngram_num = 1; }

my %model_freq;
my %input_freq;
my $unknown_score = 0;
{
    my $count = 0;
    
    open ($IN1, "< $model_file1");
    while (my $l = <$IN1>) {
	$l =~ s|\n||g;
	my @arr = split /\t/, $l;
	my $key = $arr[0];
	$key = Encode::decode_utf8($key) unless utf8::is_utf8($key);
	$model_freq{$key} = $arr[3];
	$count = $count + $arr[1];
    }
    close ($IN1);
    open ($IN2, "< $model_file2");
    while (my $l = <$IN2>) {
	$l =~ s|\n||g;
	my @arr = split /\t/, $l;
	my $key = $arr[0];
	$key = Encode::decode_utf8($key) unless utf8::is_utf8($key);
	$model_freq{$key} = $arr[3];
	$count = $count + $arr[1];
    }
    close ($IN2);
    
    $unknown_score = 1 / ($count + 1);
    
    open ($IN3, "< $input_file");
    while (my $l = <$IN3>) {
	$l =~ s|\n||g;
	my @arr = split /\t/, $l;
	my $key = $arr[0];
	$key = Encode::decode_utf8($key) unless utf8::is_utf8($key);
	$input_freq{$key}{k} = $arr[3];
	$input_freq{$key}{f} = $arr[2];
	$count = $count + $arr[1];
    }
    close ($IN3);
}

my $threshold = 0.00000000001;
my $score_sub = 1;
my $t = 0.5;
while ($score_sub > 0) {
    my $score = 0;
    my $count = 0;
    foreach my $key (keys %input_freq) {
	if (exists $model_freq{$key}) {
	    $score = $score + $input_freq{$key}{f} * (($t * $model_freq{$key}) / ($t * $model_freq{$key} + (1 - $t) * $unknown_score));
	    #print $score."\n";
	}
	$count = $count + $input_freq{$key}{f};
    }
    my $tmp = $score / $count;
    my $tmp_score_sub = 0;
    if ($tmp > $t) { $tmp_score_sub = $tmp - $t; }
    else { $tmp_score_sub = $t - $tmp; }
    print $tmp_score_sub.":".$t.":".$tmp."\n";
    $t = $tmp;
    if ($score_sub == $tmp_score_sub) { last; }
    $score_sub = $tmp_score_sub;
}
