#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use YAML;

use Apporo;

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

sub add_score {
    my ($hash_ref, $res_ref) = @_;
    foreach my $e (@{$res_ref}) {
        $e =~ s|\n||;
        my @arr = split /\t/, $e;
        my $id = $arr[$#arr];
        my $score = $arr[0];
        $hash_ref->{$id}{score} += $score;
        unless (exists $hash_ref->{$id}{entry}) {
            my $entry = $arr[$#arr];
            $hash_ref->{$id}{entry} = $entry;
        }
    }
}

sub get_total_result {
    my ($result_num, $s_ref, $y_ref, $r_ref) = @_;
    my @res;
    my %hash;
    &add_score(\%hash, $s_ref);
    &add_score(\%hash, $y_ref);
    &add_score(\%hash, $r_ref);
    my $count = 0;
    foreach my $r (sort {$hash{$b}{score} <=> $hash{$a}{score}} keys %hash) {
        push @res, $hash{$r}{score}."\t".$hash{$r}{entry};
        $count++;
        if ($count >= $result_num) { last; }
    }
    return \@res;
}

sub search {
    my $query = $ARGV[0];

    my $s_config_path = $FindBin::Bin."/../conf/mat_lex_surface.conf";
    my $y_config_path = $FindBin::Bin."/../conf/mat_lex_yomi.conf";
    my $r_config_path = $FindBin::Bin."/../conf/mat_lex_roman.conf";
    my $s_app = Apporo->new($s_config_path);
    my $y_app = Apporo->new($y_config_path);
    my $r_app = Apporo->new($r_config_path);

    my $y_query = &get_mecab_yomi($query);
    my $r_query = &get_skk_roman($y_query);

    my $s_arr = $s_app->retrieve($query);
    my $y_arr = $y_app->retrieve($y_query);
    my $r_arr = $r_app->retrieve($r_query);
    
    my $result_num = 10;
    my @res = &get_total_result($result_num, $s_arr, $y_arr, $r_arr);

    print Dump \@res;

}

&search();
