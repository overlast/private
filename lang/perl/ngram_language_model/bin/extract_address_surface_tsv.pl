#!/usr/bin/env perl

# usage: ./bin/extract_address_surface_tsv.pl ./data/13tokyo.csv > ./sample/13tokyo.tsv

use strict;
use warnings;
use utf8;
use Encode;

my $IN;
my $filename = $ARGV[0];
unless ($filename) { exit; }

open ($IN, "< $filename");
while (my $l = <$IN>) {
    $l =~ s|\n||;
    my @arr = split /,/, $l;
    my $address = $arr[6].$arr[7].$arr[8];
    $address = Encode::decode_utf8($address) unless utf8::is_utf8($address);
    $address =~ s|"||g;
    $address =~ s|以下に掲載がない場合||;
    $address = Encode::encode_utf8($address) if utf8::is_utf8($address);
    $l =~ s|"||g;
    print $address."\t".$l."\n";
}
close ($IN);


