#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Encode;

use Furl;
my $furl = Furl->new(agent => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.7 (KHTML, like Gecko) Iron/16.0.950.0 Chrome/16.0.950.0 Safari/535.7');

use Lingua::JA::Regular::Unicode qw/alnum_z2h katakana_h2z space_z2h/;;
use YAML;

sub enc_utf8 {
    my ($d) = @_;
    $d = Encode::encode_utf8($d) if utf8::is_utf8($d);
    return $d;
}

sub dec_utf8 {
    my ($d) = @_;
    $d = Encode::decode_utf8($d) unless utf8::is_utf8($d);
    return $d;
}

sub say {
    my ($text) = @_;
    print Dump &enc_utf8($text);
    return;
}

sub get_url {
    my ($query, $page) = @_;
    my $search_url = &enc_utf8("http://cookpad.com/レシピ");
    my $url = $search_url."/".&enc_utf8($query)."?page=".$page;
    return $url;
}

sub get_res {
    my ($url) = @_;
    my $res = "";
    if ($url) {
        my $tmp_res = $furl->get($url);
        if ($tmp_res->is_success) {
            $res = &dec_utf8($tmp_res->content);
            $res =~ s|\n||g;
            $res =~ s|\r||g;
            $res =~ s|\t||g;
            $res =~ s| {1,}| |g;
        }
    }
    return $res;
}

sub normalize {
    my ($data) = @_;
    $data =  space_z2h(alnum_z2h(katakana_h2z($data)));
    $data =~ s|\,||g;
    $data =~ s|\:||g;
    $data =~ tr|!"#$%&'()*+,-./:;<=>?@[\]^_`{\|}~｡､･｢｣|！”＃＄％＆’（）＊＋，−．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、・「」|;
    $data =~ s|（.+?）||g;
    $data =~ s|［.+?］||g;
    my $reg = '(?:○|◌|◍|◎|●|♨|♩|♪|♫|♬|♭|♮|♯|♠|♡|♢|♣|♤|♥|♦|♧|☀|☁|☂|☃|☄|★|☆)';
    $data =~ s|$reg||g;
    return $data;
}

sub normalize_info {
    my ($info_fef) = @_;
    for (my $i = 0; $i <= $#$info_fef; $i++) {
        my $tmp = $info_fef->[$i];
        $info_fef->[$i] = &normalize($tmp);
    }
    return;
}

sub split_mat {
    my ($mat) = @_;
    my @res = split /、/, $mat;
    my $mate = join "\,", @res;
    return $mate;
}

sub extract_info {
    my ($res) = @_;
    my @info = ();
    while ($res =~ m|<a href=\"http://cookpad.com/recipe/([0-9]+?)\" class=\"recipe-title font13" id=\"recipe_title_[0-9]+?\">(.+?)</a></span>.+?<div class=\"material\" style=\"line-height: 1.2em\"> <!----> 材料：(.+?) </div></div>|g) {
        my $id = $1;
        my $title = $2;
        my $mat = $3;
        if (($id) && ($title) && ($mat)) {
            my @tmp = ($id, $title, $mat);
            &normalize_info(\@tmp);
            my $mate = &split_mat($tmp[2]);
            $tmp[2] = $mate;
            my $tsv = join "\t", @tmp;
            push @info, $tsv;
        }
    }
    return \@info;
}

sub crawl {
    my $query = "塩";
    my $page = 1;
    my $max_page = 5000;
    while (1) {
        my $res = &get_res(&get_url($query, $page));
        my $info_ref = &extract_info($res);
        foreach my $info (@{$info_ref}) {
            print &enc_utf8($info)."\n";
        }
        $page++;
        if ($page > $max_page) { last; }
    }
}

&crawl();
