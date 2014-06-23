#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use autodie;
use Encode;
use YAML;
use URI; # Furl.pm will use URI.pm
use Furl;
use FindBin;
use File::Slurp;
use Path::Class;

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
    my $seed_url_list_path = $ARGV[0];
    &_crawl_all_seed_url($seed_url_list_path);
}

sub _mkdir {
    my ($path) = @_;
    mkdir $path unless (-d $path);
}

sub _mkdirp {
    my ($path) = @_;
    system "mkdir -p $path" unless (-d $path);
}


sub _sleep_1_sec {
    for (my $i=0; $i <= 112500; $i++) {}
}

sub _complete_url_prefix {
    my ($url) = @_;
    my $result = "";
    if ($url =~ m|^https?\:\/\/|) {
        $result = $url;
    } else {
        $result = "http://".$url;
    }
    return $result;
}

sub _strip_url {
    my ($line) = @_;
    my $url = "";
    if ($line =~ m|\t|) {
        my @arr = split /\t/, $line;
        $url = &_complete_url_prefix($arr[0]);
    } else {
        $url = &_complete_url_prefix($line);
    }
    return $url;
}

sub _get_seed_paths {
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

sub _get_content {
    my ($url) = @_;
    my $content = "";
    my $max_retry_num = 3;
    eval {
        while ($max_retry_num) {
            $max_retry_num--;
            my $res = $furl->get($url);

            &_sleep_1_sec();

            next unless $res->is_success;
            $content = $res->content;
            $content =~ s|\n{1,}||g;
            $content =~ s|[\t]| |g;
            $content =~ s|　| |g;
            $content =~ s| {1,}| |g;
            $content =~ s|\n |\n|g;
            $content = Encode::decode_utf8($content) unless utf8::is_utf8($content);
        }
    };
    warnf $@ if ($@);
    return $content;
}

sub _dump_to_file {
    my ($file_path, $data, $wanna_add) = @_;
    my $out;
    if ($wanna_add) {
        open $out, '>>:utf8', $file_path;
    } else {
        open $out, '>:utf8', $file_path;
    }
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

sub _get_spot_file_name_using_url {
    my ($url) = @_;
    my $file_name = "";
    if ($url) {
        if ($url =~ m|/phonebook/(M[0-9]{5})/([0-9]+)/(.+)/$|) {
            $file_name = $1."-".$2."-".$3.".html";
        } else {
            warnf "$url can't crawl";
        }
    }
    return $file_name;
}

sub _get_spot_file_dir_using_url {
    my ($url) = @_;
    my $file_dir = "";
    if ($url) {
        if ($url =~ m|/phonebook/(M[0-9]{5})/([0-9]{2})([0-9]{3})/(.+)/$|) {
            $file_dir = $data_root_path."/spot_data/".$1."/".$2;
        }
    }
    return $file_dir;
}

sub _get_spot_file_path_using_url {
    my ($url) = @_;
    my $file_path = "";
    if ($url) {
        my $file_dir = &_get_spot_file_dir_using_url($url);
        _mkdirp($file_dir) unless (-d $file_dir);
        my $file_name = &_get_spot_file_name_using_url($url);
        $file_path = $file_dir."/".$file_name;
    }
    return $file_path;
}

sub _did_already_clawled {
    my ($file_path) = @_;
    my $_did_clawled = 0;
    if ((-f $file_path) && (-s $file_path)) {
        $_did_clawled = 1;
    }
    return $_did_clawled;
}

sub _is_target_url {
    my ($url,) = @_;
    my $is_target = 1;
    my $out_of_target_reg = '(?:phonebook/M41001|phonebook/M12001|phonebook/M21101/|phonebook/M21102/|phonebook/M21103/|phonebook/M08015/|phonebook/M07001/)';
    if ($url =~ m|$out_of_target_reg|) {
        $is_target = 0;
    }
    return $is_target;
}


sub _crawl_all_seed_url {
    my ($seed_path,) = @_;
    my $seed_url_list_paths = &_get_seed_paths($seed_path);
    my $count = 0;
    foreach my $seed_url_list_path (@$seed_url_list_paths) {
        open my $in_handle, '<:utf8', $seed_url_list_path;
        while (my $seed_line = <$in_handle>) {
            $seed_line =~ s|\n||;
            my $seed_url = &_strip_url($seed_line);
            $count++;
            next unless (&_is_target_url($seed_url));
            my $seed_file_path = &_get_spot_file_path_using_url($seed_url);
            if (&_did_already_clawled($seed_file_path)) {
                infof "Skip $seed_file_path";
            } else {
                infof "Crawl $count $seed_file_path";
                my $content = &_get_content($seed_url);
                if ($content) {
                    &_dump_to_file($seed_file_path, $content);
                } else {
                    warnf "Can't get the content data of $seed_file_path";
                }
            }
        }
        close $in_handle;
    }
    return;
}






=pod

sub _get_page_content {
    my ($url) = @_;
    my $content = "";
    my $max_retry_num = 3;
;;;    while ($max_retry_num) {
        $max_retry_num--;
        my $res = $furl->get($url);

        &_sleep_1_sec();

        next unless $res->is_success;
        $content = $res->content;
        $content =~ s|\n{1,}||g;
        $content =~ s|[\t]| |g;
        $content =~ s|　| |g;
        $content =~ s| {1,}| |g;
        $content =~ s|\n |\n|g;
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

sub _get_content_file_name_using_url {
    my ($url) = @_;
    my $file_name = "";
    if ($url) {
        if ($url =~ m|/phonebook/(M[0-9]{5})/([0-9]+)/$|) {
            $file_name = $1."-".$2."-1.html";
        } elsif ($url =~ m|/phonebook/(M[0-9]{5})/([0-9]+)/([0-9]+\.html)$|) {
            $file_name = $1."-".$2."-".$3;
        }
    }
    return $file_name;
}

sub _extract_max_page_num {
    my ($content,) = @_;
    my $max_num = -1;
    if ($content) {
        if ($content =~ m|<a href=\"/phonebook/M[0-9]{5}/[0-9]{5}/([0-9]+)\.html\" class=\"pagination-link\">([0-9]+)</a><!--\.pagination--></p>|m) {
            my $tmp_max_num = $1;
            my $check_num = $2;
            $max_num = $tmp_max_num if ($tmp_max_num == $check_num);
        } elsif ($content =~ m|<span class=\"pagination-span\">.+?</span><a href=\"/phonebook/M[0-9]{5}/[0-9]{5}/([0-9]+)\.html\" class=\"pagination-link\">([0-9]+)</a>|m) {
            my $tmp_max_num = $1;
            my $check_num = $2;
            $max_num = $tmp_max_num if ($tmp_max_num == $check_num);
        }
    }
    return $max_num;
}

sub _normalize_spot_name {
    my ($name) = @_;
    $name =~ s|^[ ]+||g;
    $name =~ s|[ ]+$||g;
    return $name;
}

sub _get_spot_url_list {
    my ($domain, $content) = @_;
    my $url_list = [];
    if ($content) {
        my $genre_town = "";
        if ($content =~ m|<title>(.+)：[ア-ン]+電話帳</title>|) {
            $genre_town = $1;
        }
        while ($content =~ m|<td><span class=\"table-num-bg\">[0-9]+</span></td>.*?<th><a href=\"(/phonebook/M[0-9]{5}/[0-9]+/.+?/)\" title=\"(.+?)\">|g) {
            my $spot_url = $domain.$1;
            my $spot_title = $2;
            $spot_title = &_normalize_spot_name($spot_title);
            $genre_town = &_normalize_spot_name($genre_town);
            my $genre = "";
            my $town = "";
            if ($genre_town =~ m|^(.+?) (.+)$|) {
                $town = $1;
                $genre = $2;
            }
            my $entry = $spot_url."\t".$spot_title."\t".$town."\t".$genre;
            push @$url_list, $entry;
        }
    }
    return $url_list;
}

sub _is_rent_house_list_url {
    my ($url) = @_;
    my $is_rent_house = 0;
    if (($url =~ m|phonebook/M21101/|) ||
        ($url =~ m|phonebook/M21102/|) ||
        ($url =~ m|phonebook/M21103/|)) {
        $is_rent_house = 1;
    }
    return $is_rent_house;
}

sub _output_all_seed {
    my ($domain) = @_;
    my $root_url = "http://$domain/phonebook/";

    my $cate_url_file_path = $data_root_path."/m_category_url_list.dat";
    my $cate_pref_town_url_file_path = $data_root_path."/m_category_pref_town_url_list.dat";
    my $town_spot_url_file_path = $data_root_path."/m_town_spot_url_list.dat";
    my $spot_url_file_path = $data_root_path."/m_spot_url_list.dat";

     my ($cate_url_list, $cate_pref_town_url_list, $town_spot_url_list) = ([], [], []);
     if (-f $cate_url_file_path) {
         $cate_url_list = &_get_url_list_from_file($cate_url_file_path);
     } else {
         $cate_url_list = &_ouput_category_url_list($domain, $root_url);
         &_dump_to_file($cate_url_file_path, $cate_url_list);
     }

     if (-f $cate_pref_town_url_file_path) {
         $cate_pref_town_url_list = &_get_url_list_from_file($cate_pref_town_url_file_path);
     } else {
         foreach my $cate_url (@$cate_url_list) {
             $cate_url =~ s|\n||;
             for (my $i = 1; $i <= 47; $i++) {
                 my $pref_id = &_get_pref_id($i);
                 my $cate_pref_url = $cate_url.$pref_id."/";
                 my $url_list = &_get_category_pref_town_url_list($domain, $cate_pref_url);
                 # カテゴリ分類された都市ページURL一覧に書き出す
                 &_dump_to_file($cate_pref_town_url_file_path, $url_list, "add");
             }
         }
         $cate_pref_town_url_list = &_get_url_list_from_file($cate_pref_town_url_file_path);
     }

    my $town_spot_dir_path = $data_root_path."/town_spot";
    &_mkdir($town_spot_dir_path);

    unless (-f $town_spot_url_file_path) {
        foreach my $cate_pref_town_url (@$cate_pref_town_url_list) {

            $cate_pref_town_url =~ s|\n||;
            my $town_spot_file_name = &_get_content_file_name_using_url($cate_pref_town_url);
            my $town_spot_file_path = $town_spot_dir_path."/".$town_spot_file_name;
            print Dump $cate_pref_town_url;
            print Dump $town_spot_file_path;
            unless (-f $town_spot_file_path) {
                my $cate_pref_town_page_content = &_get_page_content($cate_pref_town_url);
                if (&_is_spot_of_town_page($cate_pref_town_page_content)) {
                    my $max_page_num = &_extract_max_page_num($cate_pref_town_page_content);
                    $max_page_num = 1 if ($max_page_num == -1);
                    my $url_list = [$cate_pref_town_url];
                    for (my $i = 2; $i <= $max_page_num; $i++) {
                        my $tmp_town_spot_url = $cate_pref_town_url.$i.".html";
                        print Dump &_get_content_file_name_using_url($tmp_town_spot_url);
                        push @$url_list, $tmp_town_spot_url;
                    }
                    print Dump $url_list;

                    &_dump_to_file($town_spot_file_path, $cate_pref_town_page_content);
                    &_dump_to_file($town_spot_url_file_path, $url_list, "add");
                }
            }
        }
    }

    if (-f $town_spot_url_file_path) {
        open my $tsuf_in, '<:utf8', $town_spot_url_file_path;
        while (my $town_spot_url = <$tsuf_in>) {
            $town_spot_url =~ s|\n||;
            next if (&_is_rent_house_list_url($town_spot_url));
            print Dump $town_spot_url;
            my $town_spot_file_name = &_get_content_file_name_using_url($town_spot_url);
            my $town_spot_file_path = $town_spot_dir_path."/".$town_spot_file_name;
            unless (-f $town_spot_file_path) {
                my $town_spot_page_content = &_get_page_content($town_spot_url);
                if (&_is_spot_of_town_page($town_spot_page_content)) {
                    &_dump_to_file($town_spot_file_path, $town_spot_page_content);
                }
            }
        }
        close $tsuf_in;
    }

    if (-f $town_spot_url_file_path) {
        open my $tsuf_in, '<:utf8', $town_spot_url_file_path;
        while (my $town_spot_url = <$tsuf_in>) {
            $town_spot_url =~ s|\n||;
            next if (&_is_rent_house_list_url($town_spot_url));
            print Dump $town_spot_url;
            my $town_spot_file_name = &_get_content_file_name_using_url($town_spot_url);
            my $town_spot_file_path = $town_spot_dir_path."/".$town_spot_file_name;
            if (-f $town_spot_file_path) {
                my $town_spot_page_content = &_get_content_from_file($town_spot_file_path);
                my $url_list = &_get_spot_url_list($domain, $town_spot_page_content )
;
                &_dump_to_file($spot_url_file_path, $url_list, "add");
            }
        }
        close $tsuf_in;
    }

}

sub _get_url_list_from_file {
    my ($file_path) = @_;
    my $list = [];
    if (-f $file_path) {
        @$list = read_file($file_path) ;
    }
    return $list;
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

sub _extract_category_pref_town_url_list {
    my ($domain, $content) = @_;
    my @list = ();
    if ($content) {
        while ($content =~ m|(/phonebook/M[0-9]{5}/[0-9]{5}/)|g) {
            my $cate_pref_town_url = "http://".$domain.$1;
            # リストの幅を取り出す処理に送る
            push @list, $cate_pref_town_url;
        }
    }
    return \@list;
}

sub _is_spot_of_town_page {
    my ($content) = @_;
    my $is_spot_of_town_page = -1;
    if ($content) {
        if ($content =~ m|一覧で表示しています。地図または一覧から|) {
            $is_spot_of_town_page = 1;
        }
    }
    return $is_spot_of_town_page;
}


sub _get_category_pref_town_url_list {
    my ($domain, $cate_pref_url) = @_;
    infof "$script_prefix Extract URLs of category pages for each towns list from $cate_pref_url";

    my $url_list = [];
    my $content = &_get_page_content($cate_pref_url);

    if (&_is_spot_of_town_page($content)) {
        # リストの幅を取り出す処理に送る
        push @$url_list, $cate_pref_url;
    } else {
        # カテゴリ分類された都市ページURLを取り出す
        $url_list = &_extract_category_pref_town_url_list($domain, $content);
    }
    return $url_list;
}

sub _extract_category_url_list {
    my ($domain, $content) = @_;
    my @list = ();
    if ($content) {
        while ($content =~ m|(/phonebook/M[0-9]{5}/)|g) {
            my $cate_url = "http://".$domain.$1;
            push @list, $cate_url;
        }
    }
    return \@list;
}

sub _dump_to_file {
    my ($file_path, $data, $wanna_add) = @_;
    my $out;
    if ($wanna_add) {
        open $out, '>>:utf8', $file_path;
    } else {
        open $out, '>:utf8', $file_path;
    }
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

sub _get_category_url_list {
    my ($domain, $root_url) = @_;
    infof "$script_prefix Extract category page url list from $root_url";
    my $content = &_get_page_content($root_url);
    my $category_url_list = &_extract_category_url_list($domain, $content);
    return $category_url_list;
}

=cut
