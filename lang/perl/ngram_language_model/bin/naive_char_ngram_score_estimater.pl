#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Encode;

#$./bin/naive_char_ngram_score_estimater.pl ./sample/sample.txt ./sample/char_unigram 1
#東京都渋谷区東
#    -3.73212503570323
#東京特許許可局
#    -0.766561163733927
#$./bin/naive_char_ngram_score_estimater.pl ./sample/sample.txt ./sample/char_bigram 2
#東京都渋谷区東
#    -4.9730308710526
#東京特許許可局
#    -0.448297618676389



my ($IIN, $MIN);
my $input_file = $ARGV[0];
my $model_file = $ARGV[1];
my $ngram_num = $ARGV[2];
my $lambda = $ARGV[3];

unless ($input_file) { exit; }
unless ($model_file) { exit; }
unless ($ngram_num) { $ngram_num = 1; }
unless ($lambda) { $lambda = 0.996024869331002; }

open ($IIN, "< $input_file");
open ($MIN, "< $model_file");

my %hash;
my $count = 0;

while (my $l = <$MIN>) {
    $l =~ s|\n||;
    my @arr = split /\t/, $l;
    my $key = $arr[0];
    $key = Encode::decode_utf8($key) unless utf8::is_utf8($key);
    $hash{$key} = $arr[3];
    $count = $count + $arr[1];
}
close ($MIN);

$hash{'-UNKNOWN-'} = 1 / ($count + 1);

while (my $line = <$IIN>) {
    my $l = $line;
    $l =~ s|\n||;
    $l = Encode::decode_utf8($l) unless utf8::is_utf8($l);
    $l =~ s|\n||g;
    $l =~ s|\r||g;
    $l =~ s|\s||g;
    $l =~ s|\t||g;

    my $len = length $l;
    my $max_att = $len - ($ngram_num - 1);
    my $score = 0;
    for (my $i = 0; $i < $max_att; $i++) {
	my $char = substr($l, $i, $ngram_num);
	if (exists $hash{$char}) {
	    $score = $score + ($lambda * $hash{$char}) + ((1 - $lambda) * $hash{'-UNKNOWN-'});
	}
	else {
	    $score = $score + $hash{'-UNKNOWN-'};
	}
    }
    $score = $score / $max_att;
    print $line."\t".$score."\n";
}
close ($IIN);


