#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Encode;
use YAML;

my $sample = "ようこそようそへ";

sub make_suffix_arr {
    my ($suffix_arr_ref, $text, $text_len) = @_;
    
    # 番号を保存する。この配列をいじくる。
    for (my $i = 0; $i < $text_len; $i++) {
        $suffix_arr_ref->[$i] = $i;
    }

    my @suffix_text_arr = ();
    
    # 接尾辞の保存。番号から接尾辞を参照できるようにする。
    for (my $i = 0; $i < $text_len; $i++) {
        my $suffix = substr($text, $i, $text_len);
        $suffix_text_arr[$i] = $suffix;
    }

    for (my $i = 0; $i < $text_len; $i++) {
        for (my $j = $i; $j < $text_len; $j++) {
            my $suf1 = $suffix_text_arr[$suffix_arr_ref->[$i]];
            my $suf2 = $suffix_text_arr[$suffix_arr_ref->[$j]];

#            print $suf1." : ".$suf2." : ".($suf1 cmp $suf2). "\n";

             if (($suf2 cmp $suf1) == -1) {
                my $tmp_num = $suffix_arr_ref->[$j];
                $suffix_arr_ref->[$j] = $suffix_arr_ref->[$i];
                $suffix_arr_ref->[$i] = $tmp_num;
            }
        }
    }
    
#    print Dump $suffix_arr_ref;
#    for (my $i = 0; $i < $text_len; $i++) {
#        print Dump $suffix_text_arr[$suffix_arr_ref->[$i]];
#    }

    return;
}

sub fetch {
    my ($text) = @_;
    $text = Encode::decode_utf8($text) unless utf8::is_utf8($text);
    my $text_len = length $text;
    my @suffix_arr = ();
    &make_suffix_arr(\@suffix_arr, $text, $text_len);
    print Dump \@suffix_arr;
}

&fetch($sample);
