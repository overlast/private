#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Encode;
use MeCab;
use Lingua::JA::Romanize::Japanese;

use FindBin;

sub get_mecab_yomi {
    my ($text) = @_;
    my $res = "";
    my $m = new MeCab::Tagger("-Ochasen");
    my $n = $m->parseToNode($text);
    my @yomi_arr = ();
    while ($n = $n->{next}) {
        if ($n->{surface}) {
            my @arr = split "\,", $n->{feature};
            my $tmp = "";
            if (($#arr < 7) || ($arr[7] eq "*")) {
                $tmp = $n->{surface};
            }
            else {
                $tmp = $arr[7];
            }
            push @yomi_arr, $tmp;
        }
    }
    if (@yomi_arr) {
        $res = join "", @yomi_arr;
    }
    return $res;
}

sub get_skk_roman {
    my ($data) = @_;
    my $conv = Lingua::JA::Romanize::Japanese->new();
    my @roman_arr = $conv->string( $data );
    my @ruby;
    foreach my $ref (@roman_arr) {
        my ($raw, $ruby) = @{$ref};
        if (defined $ruby) {
            push @ruby, $ruby;
        }
        else {
            push @ruby, $raw;
        }
    }
    my $roman = join "", @ruby;
    return $roman;
}

sub process {
    my $infile_path = $ARGV[0];
    unless ($infile_path =~ m|^/|) {
        $infile_path = $FindBin::Bin."/".$infile_path;
    }
    my $in;
    open ($in, "< $infile_path");
    while (my $l = <$in>) {
        unless ($l) { next; }
        $l =~ s|\n||;
        my @arr = split /\t/, $l;
        my $target = $arr[0];
        if ($target) {
            my $yomi = &get_mecab_yomi($target);
            my $roman = &get_skk_roman($yomi);
            print $yomi."\t".$roman."\t".$l."\n";
        }
    }
    close ($in);
}

&process();


