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

sub search_keyword_position {
    my ($result_arr_ref, $suffix_arr_ref, $text, $text_len, $query, $query_len) = @_;
    
    my $i = int (($text_len - 1) / 2);
   # print Dump $text_len,$i, $query_len;
    my $search_width = int ($text_len - 1);
    my $is_match = 0;
    my $left = 0;
    my $right = $text_len - 1;
    while ($search_width > 0) {
        my $j = $suffix_arr_ref->[$i];
        my $count = 0;
        while ($count <= $text_len) {
            my $suf_char = substr($text, $j + $count, 1);
            if ($suf_char eq "") {
                last;
            }
            $count++;
        }
        my $suffix = substr($text, $j, $count);
        print Dump "suffix  $suffix, $count, $query_len";
        my $comp_len = $query_len; 
        unless ($count >= $query_len) {
            $comp_len = $count;
        }
        my $substr_suffix = substr($text, $j, $query_len);
        print Dump $substr_suffix;
        my $order = ($query cmp $substr_suffix);
        print Dump "====", $j, $order, "===";
        if ($order == 1) {
            print Dump "$i : $query_len";
            $left = $i;
            $i = int (($left + $right)/2);
            $search_width = int($search_width / 2);
        }
        elsif ($order == -1) {
            $right = $i;
                $i = int (($left + $right)/2);
            $search_width = int($search_width / 2);
        }
        elsif ($order == 0) {
            $is_match = 1;
            last;
        }
        sleep(1);
    }
    
    if ($is_match) {
        my $entry_begin = $i;
        my $entry_end = $i;
        while (1) {
            my $j = $suffix_arr_ref->[$entry_begin];
            my $substr_suffix = substr($text, $j, $query_len);
#            print Dump "hou", $j, $substr_suffix, "===";
            my $order = ($query cmp $substr_suffix);
#            print Dump "order $order";
            if ($order == 0) {
                if ($entry_begin >= 0) {
                    $entry_begin--;
                }
                else {
                    last;
                }
            }
            else {
                last;
            }
        }
        while (1) {
            my $j = $suffix_arr_ref->[$entry_end];
            my $substr_suffix = substr($text, $j, $query_len);
            #print Dump $substr_suffix;
            my $order = ($query cmp $substr_suffix);
            if ($order == 0) {
                if ($entry_end < $text_len) {
                    $entry_end++;
                }
                else {
                    last;
                }
            }
            else {
                last;
            }
        }
        if (($i - $entry_begin) > 0) {
            $entry_begin = $entry_begin + 1;
        }
        if (($entry_end - $i) > 0) {
            $entry_end = $entry_end - 1;
        }
        print Dump $entry_begin, $entry_end;
        
        for(my $k = $entry_begin; $k <= $entry_end; $k++) {
            push @{$result_arr_ref}, $suffix_arr_ref->[$k];
        }
    }
    #print Dump $result_arr_ref;
    return;
}

sub make_bit_vector {
    my ($bit_vector_arr_ref, $suffix_arr_ref, $text_len) = @_;
    for (my $i = 0; $i < $text_len; $i++) {
        if (($suffix_arr_ref->[$i] % 2) != 0) {
            $bit_vector_arr_ref->[$i] = 1;
        }
        else {
            $bit_vector_arr_ref->[$i] = 0;
        }
    }
    return;
}

sub make_psi_and_sample_vector {
    my ($psi_vector_arr_ref, $sample_vector_arr_ref, $suffix_arr_ref, $text_len) = @_;
    for (my $i = 0; $i < $text_len; $i++) {
        if (($suffix_arr_ref->[$i] % 2) != 0) {
            $psi_vector_arr_ref->[$i] = "";
            $sample_vector_arr_ref->[$i] = $suffix_arr_ref->[$i];
        }
        else {
            for (my $j = 0; $j < $text_len; $j++) {
                if ($suffix_arr_ref->[$i] eq ($suffix_arr_ref->[$j] - 1)) {
                    $psi_vector_arr_ref->[$i] = $j;
                    $sample_vector_arr_ref->[$i] = "";
                }
            }
        }
        
    }
}
        

sub fetch {
    my ($text) = @_;
    $text = Encode::decode_utf8($text) unless utf8::is_utf8($text);
    my $text_len = length $text;
    my @suffix_arr = (); # テキストの文字長
    &make_suffix_arr(\@suffix_arr, $text, $text_len);
    print Dump \@suffix_arr;
    my @result_arr = (); # 最大で欲しい検索結果数分
    my $query = 'ほげ';
    my $query_len = length $query;
    &search_keyword_position(\@result_arr, \@suffix_arr, $text, $text_len, $query, $query_len);
    print Dump \@result_arr;
    my @bit_vector_arr = (); # テキストの文字長
    &make_bit_vector(\@bit_vector_arr, \@suffix_arr, $text_len);
    print Dump \@bit_vector_arr;
    my @psi_vector_arr = (); # テキストの文字長
    my @sample_vector_arr = (); # テキストの文字長
    &make_psi_and_sample_vector(\@psi_vector_arr, \@sample_vector_arr, \@suffix_arr, $text_len);
    print Dump \@psi_vector_arr;
    print Dump \@sample_vector_arr;
}

&fetch($sample);
