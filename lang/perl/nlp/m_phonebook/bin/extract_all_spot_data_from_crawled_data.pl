#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use autodie;
use Encode;
use YAML;
use FindBin;
use File::Slurp;
use Path::Class;
use JSON;

use constant LM_DEBUG => $ENV{LM_DEBUG};
use Log::Minimal qw/debugf infof warnf critf/; # $ENV{LM_LEVEL}
$Log::Minimal::AUTODUMP = 1;
$Log::Minimal::COLOR = 1;
$Log::Minimal::LOG_LEVEL = "DEBUG";

my $script_prefix = "[extract_all_spot_data] : ";
my $data_root_path = $FindBin::Bin."/../data";
&_mkdir($data_root_path);

&main();

sub main {
    my $root_dir_path = $ARGV[0];
    &_extract_all_spot_data($root_dir_path);
}

sub _mkdir {
    my ($path) = @_;
    mkdir $path unless (-d $path);
}

sub _get_child_paths {
    my ($path) = @_;
    my @seed_paths;
    if (-d $path) {
        my @path_classes = dir($path)->children;
        foreach my $path_class (@path_classes) {
             my $seed_path = $path_class->absolute->stringify;
             push @seed_paths, "$seed_path";
        }
    } elsif (-f $path) {
        push  @seed_paths, $path;
    }
    return \@seed_paths;
}

sub _is_valid_category_html_path {
    my ($html_path) = @_;
    my $is_valid = 1;
    my $ignore_category_path_reg = '(?:/M41001/|/M12001/|/M21101/|/M21102/|/M21103/|/M08015/|/M07001/)';
    if ($html_path =~ m|$ignore_category_path_reg|) {
        $is_valid = 0;
    }
    return $is_valid;
}

sub _get_content_from_file {
    my ($file_path) = @_;
    my $content = "";
    if (-f $file_path) {
        my @list = read_file($file_path) ;
        if (@list) {
            $content = join "", @list;
        }
        $content = Encode::decode_utf8($content) unless utf8::is_utf8($content);
    }
    return $content;
}


sub _normalize_html {
    my ($html,) = @_;
    my $normalized_html = "";
    if ($html) {
        $normalized_html = $html;
        $normalized_html =~ s|[\n\r\t]{1}||g;
        $normalized_html =~ s|[ ]{1,}| |g;
        $normalized_html =~ s|>[ ]{1}<|><|g;
    }
    return $normalized_html;
}

sub _extract_spot_basic_table {
    my ($html,) = @_;
    my $table = "";
    if (($html) && ($html =~ m|<div class=\"spot-basic\">(.+</table>)</div>|)) {
        $table = $1;
    }
    return $table;
}

sub _extract_spot_tel_tag {
    my ($html,) = @_;
    my $table = "";
    if (($html) && ($html =~ m|<div class=\"spot-tel-tag\">(.+)<!-- \.spot-tel-tag --></div>|)) {
        $table = $1;
    }
    return $table;
}


sub _build_spot_data_map {
    my ($spot_basic_table, $spot_tel_tag) = @_;
    my $spot_data_map = {};
    my ($surface, $yomi, $post_code, $address, $latitude, $longitude, $spot_id, $tel, $nearest_station_id, $nearest_station_surface, $distance_from_nearest_station);

#<table cellspacing=\"0\" border=\"0\" class=\"spot-table-basic\"><tr><th>名称</th><td> 上田中央消防署</td></tr><tr><th>よみがな</th><td>うえだちゅうおうしょうぼうしょ</td></tr><tr><th>住所</th><td>〒386-0024<br />長野県上田市大手２−７−１６<div class=\"arrow_navi\"><a href=\"/m/36.4014194_138.25125_8/poi=L20101015400000000043/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_navi_to_poi\">この場所への行き方を見る</a></div></td></tr><tr><th>最寄駅<br />（直線距離）</th><td><a href=\"/station/ST24129/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_stationdir\">上田駅</a><span class=\"spot-table-ex\"> （912ｍ）</span>


    if ($spot_basic_table =~ m|<th>名称</th><td>(.+?)</td></tr><tr><th>よみがな</th><td>(.+?)</td></tr><tr><th>住所</th><td>〒([0-9]+\-[0-9]+)<br />(.+?)<div class=\"arrow_navi\"><a href=\"/m/([0-9\.]+)_([0-9\.]+).+?/poi=(.+?)/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_navi_to_poi\">この場所への行き方を見る</a></div></td></tr><tr><th>電話番号</th><td>(.+?)</td></tr><tr><th>最寄駅<br />（直線距離）</th><td><a href=\"/station/(.+?)/" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_stationdir\">(.+?)</a><span class=\"spot-table-ex\">（(.+?)ｍ）</span>|) {

        ($surface, $yomi, $post_code, $address, $latitude, $longitude, $spot_id, $tel, $nearest_station_id, $nearest_station_surface, $distance_from_nearest_station) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

    } elsif ($spot_basic_table =~ m|<th>名称</th><td>(.+?)</td></tr><tr><th>よみがな</th><td>(.+?)</td></tr><tr><th>住所</th><td>〒([0-9]+\-[0-9]+)<br />(.+?)<div class=\"arrow_navi\"><a href=\"/m/([0-9\.]+)_([0-9\.]+).+?/poi=(.+?)/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_navi_to_poi\">この場所への行き方を見る</a></div></td></tr><tr><th>最寄駅<br />（直線距離）</th><td><a href=\"/station/(.+?)/" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_stationdir\">(.+?)</a><span class=\"spot-table-ex\">（(.+?)ｍ）</span>|) {

        ($surface, $yomi, $post_code, $address, $latitude, $longitude, $spot_id, $nearest_station_id, $nearest_station_surface, $distance_from_nearest_station) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,);

    } elsif ($spot_basic_table =~ m|<th>名称</th><td>(.+?)</td></tr><tr><th>よみがな</th><td>(.+?)</td></tr><tr><th>住所</th><td>(.+?)<div class=\"arrow_navi\"><a href=\"/m/([0-9\.]+)_([0-9\.]+).+?/poi=(.+?)/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_navi_to_poi\">この場所への行き方を見る</a></div></td></tr><tr><th>最寄駅<br />（直線距離）</th><td><a href=\"/station/(.+?)/" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_stationdir\">(.+?)</a><span class=\"spot-table-ex\">（(.+?)ｍ）</span>|) {

        ($surface, $yomi, $address, $latitude, $longitude, $spot_id, $nearest_station_id, $nearest_station_surface, $distance_from_nearest_station) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,);

    } elsif ($spot_basic_table =~ m|<th>名称</th><td>(.+?)</td></tr><tr><th>よみがな</th><td>(.+?)</td></tr><tr><th>住所</th><td>〒([0-9]+\-[0-9]+)<br />(.+?)<div class=\"arrow_navi\"><a href=\"/m/([0-9\.]+)_([0-9\.]+).+?/poi=(.+?)/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_navi_to_poi\">この場所への行き方を見る</a></div></td></tr><tr><th>電話番号</th><td>(.+?)</td></tr>|) {

        ($surface, $yomi, $post_code, $address, $latitude, $longitude, $spot_id, $tel,) = ($1, $2, $3, $4, $5, $6, $7, $8,);

    } elsif ($spot_basic_table =~ m|<th>名称</th><td>(.+?)</td></tr><tr><th>よみがな</th><td>(.+?)</td></tr><tr><th>電話番号</th><td><p class="spot-basic-tel"><span class="spot-basic-tel-num">(.+?)</span>.*?</p></td></tr><tr><th>住所</th><td><span rel=\"v:address\"> 〒<span property=\"v:postal-code\">([0-9]+\-[0-9]+)</span><br />(.+?)<span.*?<br /><a data-analytics=\"phonebook/detail/to_navi_to_poi\" href=\"/m/([0-9\.]+)_([0-9\.]+).+?/poi=(.+?)/\" class=\"spot-table-link\">この場所への行き方を見る</a></td></tr><tr><th>最寄駅<br />（直線距離）</th><td><a href=\"/station/(.+?)/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_stationdir\">(.+?)</a><span class=\"spot-table-ex\">（(.+?)ｍ）</span>|)
 {
        ($surface, $yomi, $tel, $post_code, $address, $latitude, $longitude, $spot_id,  $nearest_station_id, $nearest_station_surface, $distance_from_nearest_station) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

    } elsif ($spot_basic_table =~ m|<th>名称</th><td>(.+?)</td></tr><tr><th>よみがな</th><td>(.+?)</td></tr><tr><th>電話番号</th><td><p class="spot-basic-tel"><span class="spot-basic-tel-num">(.+?)</span>.*?</p></td></tr><tr><th>住所</th><td><span rel=\"v:address\">(.+?)<span.*?<br /><a data-analytics=\"phonebook/detail/to_navi_to_poi\" href=\"/m/([0-9\.]+)_([0-9\.]+).+?/poi=(.+?)/\" class=\"spot-table-link\">この場所への行き方を見る</a></td></tr><tr><th>最寄駅<br />（直線距離）</th><td><a href=\"/station/(.+?)/\" class=\"spot-table-link\" data-analytics=\"phonebook/detail/to_stationdir\">(.+?)</a><span class=\"spot-table-ex\">（(.+?)ｍ）</span>|)
 {
        ($surface, $yomi, $tel, $address, $latitude, $longitude, $spot_id,  $nearest_station_id, $nearest_station_surface, $distance_from_nearest_station) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,);

    }

    if ($surface) {
        $spot_data_map->{surface} = $surface if ($surface);
        $spot_data_map->{yomi} = $yomi if ($yomi);
        $spot_data_map->{post_code} = $post_code if ($post_code);
        $spot_data_map->{address} = $address if ($address);
        $spot_data_map->{latitude} = $latitude if ($latitude);
        $spot_data_map->{longitude} = $longitude if ($longitude);
        $spot_data_map->{spot_id} = $spot_id if ($spot_id);
        $spot_data_map->{tel} = $tel if ($tel);
        $spot_data_map->{nearest_station_id} = $nearest_station_id if ($nearest_station_id);
        $spot_data_map->{nearest_station_surface} = $nearest_station_surface if ($nearest_station_surface);
        $spot_data_map->{distance_from_nearest_station} = $distance_from_nearest_station if ($distance_from_nearest_station);
    }


    my ($genres, $genre_id, $pref_id, $pref_surface, $city_id, $city_surface);


    if ($spot_tel_tag =~ m|<th class=\"spot-tag-span\">ジャンル</th><td>(.+?)</td></tr><tr><th class=\"spot-tag-span\">施設所在地</th><td><a href=\"/phonebook/(M[0-9]+)/([0-9]+)/\" title=\".+?\" data-id=\"link-area-pref\" class=\"spot-tag-link\">(.+?)</a><a href=\"/phonebook/M[0-9]+/([0-9]+)/\" title=\".+?\" data-id=\"link-area-city\" class=\"spot-tag-link\">(.+?)</a><a href=\"/phonebook/.+?/\" title=\".+?\" class=\"spot-tag-link\">.+駅</a>|) {

        ($genres, $genre_id, $pref_id, $pref_surface, $city_id, $city_surface) = ($1, $2, $3, $4, $5, $6);

    } elsif ($spot_tel_tag =~ m|<th class=\"spot-tag-span\">ジャンル</th><td>(.+?)</td></tr><tr><th class=\"spot-tag-span\">施設所在地</th><td><a href=\"/phonebook/(M[0-9]+)/([0-9]+)/\" title=\".+?\" data-id=\"link-area-pref\" class=\"spot-tag-link\">(.+?)</a><a href=\"/phonebook/M[0-9]+/([0-9]+)/\" title=\".+?\" data-id=\"link-area-city\" class=\"spot-tag-link\">(.+?)</a>|) {

        ($genres, $genre_id, $pref_id, $pref_surface, $city_id, $city_surface) = ($1, $2, $3, $4, $5, $6);

    }

    if ($genres) {
        my @genre_id_arr = ();
        my @genre_surface_arr = ();
        while ($genres =~ m|<a href=\"/phonebook/(M[0-9]+)/\" title=\"(.+?)\" data-id|g) {
            my ($tmp_id, $tmp_surface) = ($1, $2);
            push @genre_id_arr, $tmp_id;
            push @genre_surface_arr, $tmp_surface;
        }
        my $genre_ids_csv = join ',', @genre_id_arr;
        my $genre_surface_csv = join ',', @genre_surface_arr;
        $spot_data_map->{genre_ids_csv} = $genre_ids_csv if ($genre_ids_csv);
        $spot_data_map->{genre_surface_csv} = $genre_surface_csv if ($genre_surface_csv);
        $spot_data_map->{genre_id} = $genre_id if ($genre_id);
        $spot_data_map->{pref_id} = $pref_id if ($pref_id);
        $spot_data_map->{pref_surface} = $pref_surface if ($pref_surface);
        $spot_data_map->{city_id} = $city_id if ($city_id);
        $spot_data_map->{city_surface} = $city_surface if ($city_surface);
    }

    foreach my $key (keys %$spot_data_map) {
        my $val = $spot_data_map->{$key};
        my $normalized_val = &_normalize_string($val);
        $spot_data_map->{$key} = $normalized_val;
    }

    return $spot_data_map;
}

sub _normalize_string {
    my ($str) = @_;
    $str =~ s|^[ ]+||g;
    $str =~ s|[ ]+$||g;
    return $str;
}

sub _has_information {
    my ($content) = @_;
    my $has_information = 0;
    my $table_column_reg = '(?:よみがな|電話番号)';
    if ($content =~ m|$table_column_reg|) {
        $has_information = 1;
    }
    return $has_information;
}


sub _extract_spot_data {
    my ($html_path) = @_;
    my $data = "";
    if (($html_path) && (-f $html_path) && (-s $html_path)) {
        my $content = &_get_content_from_file($html_path);
        $content = &_normalize_html($content);
        my $spot_basic_table = &_extract_spot_basic_table($content);
        my $spot_tel_tag = &_extract_spot_tel_tag($content);
        if (($spot_basic_table) && (&_has_information($spot_basic_table)) && ($spot_tel_tag)) {
            $data = &_build_spot_data_map($spot_basic_table, $spot_tel_tag);
            print Dump $data;
            unless (exists $data->{surface}) {
                print Dump $spot_basic_table; die;
            }
        } else {
            warnf "$script_prefix Error is occurred by $html_path when extracting basic_table or spot_tel_tag";
        }
    }
    return $data;
}

sub _output_spot_data_json {
    my ($data) = @_;
    if (($data) && (ref $data eq "HASH") && (%$data)) {
        my $json = JSON->new->encode($data);
        print Encode::encode_utf8($json)."\n";
    }
    return;
}



sub _extract_all_spot_data {
    my ($root_path) = @_;
    my $spot_category_paths = &_get_child_paths($root_path);
    foreach my $spot_category_path (@$spot_category_paths) {
        my $spot_category_pref_paths = &_get_child_paths($spot_category_path);
        foreach my $spot_category_pref_path (@$spot_category_pref_paths) {
            my $spot_html_file_paths = &_get_child_paths($spot_category_pref_path);
            foreach my $spot_html_file_path (@$spot_html_file_paths) {
                next unless (&_is_valid_category_html_path($spot_html_file_path));
                infof "$script_prefix Extract spot data from $spot_html_file_path";
                my $data = &_extract_spot_data($spot_html_file_path);
                if ($data) {
                    &_output_spot_data_json($data);
                }
            }
        }
    }
    return;
}
