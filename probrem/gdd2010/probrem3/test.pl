#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use LWP::Simple;
use YAML;
use JSON;

my $input1 = << '__INPUT1__';
青葉城跡 38.251127 140.855294
襟裳岬 41.926490 143.246642
日本武道館 35.693242 139.749873
__INPUT1__

my $input2 = << '__INPUT2__';
札幌時計台 43.062603 141.353642
種子島宇宙センター 30.375112 130.957717
宗谷岬 45.522744 141.936603
日光東照宮 36.758051 139.598899
幕張メッセ 35.646701 140.036654
東京ビッグサイト 35.629898 139.794127
__INPUT2__

my $input3 = << '__INPUT3__';
首里城 26.216991 127.719362
大阪城 34.687353 135.525855
通天閣 34.652554 135.506333
五条大橋 34.995682 135.767890
東大寺大仏殿 34.689023 135.839880
法隆寺 34.614756 135.734254
日光東照宮 36.758051 139.598899
船の科学館 35.620168 139.772157
幕張メッセ 35.646701 140.036654
京都リサーチパーク 34.994707 135.740076
__INPUT3__

sub parse_input {
    my ($area_name_arr_ref, $latlong_arr_ref, $input) = @_;
    my %hash = ();
    my @line_arr = split /\n/, $input;
    my $count = 0;
    foreach my $l (@line_arr) {
        my @geo_arr = split / /, $l;
        if (exists $hash{$geo_arr[0]}) {
        }
        else {
            $hash{$geo_arr[0]} = 1;
            $area_name_arr_ref->[$count] = $geo_arr[0];
            $latlong_arr_ref->[$count] = $geo_arr[1].",".$geo_arr[2];
            $count++;
        }
    }
    return $count;
}

sub fetch {
    my ($input) = @_;
    my @area_name_arr = ();
    my @latlong_arr = ();
    my $input_len = &parse_input(\@area_name_arr, \@latlong_arr, $input);
    my %hash = ();
    for (my $i = 0; $i < $input_len; $i++) {
        my $latlon_org = $latlong_arr[$i];
        for (my $j = $i + 1; $j < $input_len; $j++) {
            my $latlon_des = $latlong_arr[$j];
            my $url = "http://maps.google.com/maps/api/directions/json?origin=".$latlon_org."&destination=".$latlon_des."&sensor=false&mode=driving";
            my $content = get($url);
            my $hash_ref = decode_json($content);
            my $time = $hash_ref->{routes}->[0]->{legs}->[0]->{duration}->{value};
            $hash{$i}{$j} = $time;
        }
    }

    

}

&fetch($input1);

