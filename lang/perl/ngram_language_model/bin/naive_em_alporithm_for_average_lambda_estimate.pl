#!/usr/bin/env perl

# usage: ./bin/naive_em_alporithm_for_lambda_estimate.pl ./sample/config.txt 1 #for unigram
# usage: ./bin/naive_em_alporithm_for_lambda_estimate.pl ./sample/config.txt 2 #for bigram

use strict;
use warnings;
use utf8;
use Encode;

my $config = $ARGV[0];
my $ngram_num = $ARGV[1];
unless ($config) { exit; }
unless ($ngram_num) { $ngram_num = 1; }

my ($IN);
my @files;
open ($IN, "< $config") ;
while (my $l = <$IN>) {
    $l =~ s|\n||g;
    if (-f $l) {
	push @files, $l;
    }
}
close($IN);

my $total_score = 0;

for (my $d = 0; $d <= $#files; $d++) {

    my %model_freq;
    my %input_freq;

    my $count = 0;
    open ($IN, "< $files[0]");
    while (my $l = <$IN>) {
	$l =~ s|\n||g;
	my @arr = split /\t/, $l;
	my $key = $arr[0];
	$key = Encode::decode_utf8($key) unless utf8::is_utf8($key);
	$input_freq{$key}{k} = $arr[3];
	$input_freq{$key}{f} = $arr[2];
    }
    close ($IN);

    my $unknown_score = 0;
    for (my $td = 1; $td <= $#files; $td++) {
	open ($IN, "< $files[$td]");
	while (my $l = <$IN>) {
	    $l =~ s|\n||g;
	    my @arr = split /\t/, $l;
	    my $key = $arr[0];
	    $key = Encode::decode_utf8($key) unless utf8::is_utf8($key);
	    $model_freq{$key} = $arr[3];
	    $count = $count + $arr[1];
	}
	close ($IN);
    }
    $unknown_score = 1 / ($count + 1);
    
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
    
    $total_score = $total_score + $t;
    
    my $tmp_filename = shift @files;
    push @files, $tmp_filename;
}

$total_score = $total_score / ($#files + 1);
print "lambda = ".$total_score."\n";
