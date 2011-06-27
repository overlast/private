#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Encode;

#$ ./bin/naive_make_chars_count_data.pl ./sample/13tokyo.tsv 1 > ./sample/char_unigram
#$ ./bin/naive_make_chars_count_data.pl ./sample/13tokyo.tsv 2 > ./sample/char_bigram

my $IN;
my $filename = $ARGV[0];
my $ngram_num = $ARGV[1];
unless ($filename) { exit; }
unless ($ngram_num) { $ngram_num = 1; }

open ($IN, "< $filename");
my %hash;
my $count = 0;
while (my $l = <$IN>) {
    my @arr = split /\t/, $l;
    my $key = $arr[0];
    $key = Encode::decode_utf8($key) unless utf8::is_utf8($key);
    $key =~ s|\n||g;
    $key =~ s|\r||g;
    $key =~ s|\s||g;
    $key =~ s|\t||g;

    my $len = length $key;
    my $max_att = $len - ($ngram_num - 1);
    for (my $i = 0; $i < $max_att; $i++) {
	my $char = substr($key, $i, $ngram_num);
	$char = Encode::encode_utf8($char) if utf8::is_utf8($char);
	$hash{$char}++;
	$count++;
    }
}

foreach my $key (sort { $hash{$b} <=> $hash{$a} } keys %hash){
    my $score = $hash{$key}/$count;
    my $log = log($score);
    print "$key\t$hash{$key}\t".$score."\t".$log."\n";
}


close ($IN);


