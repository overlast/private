#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use autodie;
use Encode;
use YAML;
use Furl;
use FindBin;

use constant LM_DEBUG => $ENV{LM_DEBUG};
use Log::Minimal qw/debugf infof warnf critf/; # $ENV{LM_LEVEL}
$Log::Minimal::AUTODUMP = 1;
$Log::Minimal::COLOR = 1;
$Log::Minimal::LOG_LEVEL = "DEBUG";

my $script_prefix = "[get_townpage_seed] : ";
my $furl = Furl->new(
    agent   => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36',
    timeout => 10,
);
my $data_root_path = $FindBin::Bin."/../data";
&_mkdir($data_root_path);

&main();

sub main {
    &_output_all_seed();
}

sub _mkdir {
    my ($path) = @_;
    mkdir $data_root_path unless (-d $data_root_path);
}

sub _sleep_1_sec {
    for (my $i=0; $i <= 5000000; $i++) {}
}

sub _get_page_content {
    my ($url) = @_;
    my $content = "";
    my $max_retry_num = 3;
    while ($max_retry_num) {
        $max_retry_num--;
        my $res = $furl->get($url);

        &_sleep_1_sec();

        next unless $res->is_success;
        $content = $res->content;
        $content = Encode::decode_utf8($content) unless utf8::is_utf8($content);
    }
    return $content;
}

sub _get_pref_id {
    my ($num) = @_;
    my $pref_id = -1;
    if (($num > 0) && ($num < 48)) {
        $pref_id = $num;
        if ($num < 10) {
            $pref_id = "0".$pref_id;
        }
    }
    return $pref_id;
}

sub _output_all_seed {
    my $root_url = "http://www.mapion.co.jp/phonebook/";
    my $cate_url_list = &_ouput_category_url_list($root_url);
    foreach my $cate_url (@$cate_url_list) {
        for (my $i = 1; $i <= 47; $i++) {
            my $pref_id = &_get_pref_id($i);
            my $cate_pref_url = $cate_url.$pref_id."/";
            my $cate_pref_town_url_list = &_ouput_cate_pref_town_url_list($cate_pref_url);
        }
    }
}



sub _ouput_cate_pref_town_url_list {
    my ($cate_pref_url) = @_;
    my $url_list = [];
    my $content = &_get_page_content($cate_pref_url);

    if ($content =~ m|一覧で表示しています。地図または一覧から|) {

    } else {

    }

    die;
    return $url_list;
}

sub _get_category_url_list {
    my ($content, $pref_url) = @_;
    my @list = ();
    if ($content) {
        while ($content =~ m|(/phonebook/M[0-9]{5}/)|g) {
            my $cate_url = "http://www.mapion.co.jp".$1;
            push @list, $cate_url;
        }
    }
    return \@list;
}

sub _dump_to_file {
    my ($file_path, $data) = @_;
    open my $out, '>:utf8', $file_path;
    my $entry_num = 0;
    if (ref $data eq "ARRAY") {
        foreach my $item (@$data) {
            print $out $item."\n";
            $entry_num++;
        }
    } elsif (ref $data eq "HASH") {
        foreach my $key (keys %$data) {
            my $value = $data->{$key};
            my $line = $key."\t".$value;
            print $out $line."\n";
            $entry_num++;
        }
    } else {
        my @arr = split /\n/, $data;
        foreach my $line (@arr) {
            $line =~ s|\n||;
            print $out $line."\n";
            $entry_num++;
        }
    }
    close $out;
    return $entry_num;
}

sub _ouput_category_url_list {
    my ($root_url) = @_;
    infof "$script_prefix Extract category page url list from $root_url";
    my $content = &_get_page_content($root_url);
    my $category_url_list = &_get_category_url_list($content);
    my $dump_file_path = $data_root_path."/mapion_category_url_list.dat";
    &_dump_to_file($dump_file_path, $category_url_list);
    return $category_url_list;
}


=pod


sub main {
    &_output_all_pref_seed();
}



sub _output_all_pref_seed {
    for (my $i = 1; $i <= 47; $i++) {
        infof "$script_prefix Get seed of the prefecture $i";
        my $pref_id = &_get_pref_id($i);
        for (my $genre_id = 1; $genre_id <= 15; $genre_id++) {
            infof "$script_prefix Get seed of the genre $genre_id of the prefecture $i";
            my $pref_url = "http://itp.ne.jp/genre/location/area/$pref_id/$genre_id/";
            my $city_url_list = &_output_all_city_seed($pref_url);
            foreach my $city_url (@$city_url_list) {
                my $ward_url_list = &_output_all_ward_seed($city_url);
                foreach my $ward_url (@$ward_url_list) {
                }
            }
        }
    }
}



sub _get_city_url_list {
    my ($content, $pref_url) = @_;
    my @list = ();
    if ($content) {
        if ($pref_url =~ m|.+/([0-9])/$|) {
            my $genre_id = $1;
            while ($content =~ m|(http://itp.ne.jp/genre/location/area/[0-9]{5}/$genre_id/)|g) {
                my $city_url = $1;
                push @list, $city_url;
            }
        }
    }
    return \@list;
}

sub _output_all_city_seed {
    my ($pref_url) = @_;
    infof "$script_prefix Extract city page url list from $pref_url";
    my $content = &_get_page_content($pref_url);
    my $city_url_list = &_get_city_url_list($content, $pref_url);
    return $city_url_list;
}

sub _get_ward_url_list {
    my ($content, $city_url) = @_;
    my @list = ();
    if ($content) {
        if ($city_url =~ m|.+/([0-9])/$|) {
            my $genre_id = $1;
            while ($content =~ m|(http://itp.ne.jp/genre/location/area/[0-9]{5}/$genre_id/)|g) {
                my $city_url = $1;
                push @list, $city_url;
            }
        }
    }
    return \@list;
}

sub _output_all_ward_seed {
    my ($city_url) = @_;
    infof "$script_prefix Extract ward page url list from $city_url";
    my $content = &_get_page_content($city_url);
    my $ward_url_list = &_get_ward_url_list($content, $city_url);
    return $ward_url_list;
}

=cut
