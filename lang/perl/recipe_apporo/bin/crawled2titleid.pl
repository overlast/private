#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use FindBin;

sub process {
    my $infile_path = $ARGV[0];
    unless ($infile_path =~ m|^/|) {
        $infile_path = $FindBin::Bin."/".$infile_path;
    }
    my $in;
    open ($in, "< $infile_path");
    while (my $l = <$in>) {
        $l =~ s|\n||;
        my @arr = split /\t/, $l;
        print $arr[1]."\t", $arr[0]."\n";
    }
    close ($in);
}

&process();

