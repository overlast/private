package Akamon::Query;

use strict;
use warnings;
use utf8;

use YAML;

# 引用符が超優先な気がする。

#
# input  : (fullなクエリ文字列, クエリの区切り文字)
# output :  クエリを区切って作った配列
#
# フレーズクエリの
#
sub aka_get_query_arr {
    my ($self, $query, $query_boundary, $phrase_boundary) = @_;
    my @query_arr = ();
    unless ($query_boundary) {
	$query_boundary = ' '; #区切り文字が無かったら半角スペース
    }
    unless ($phrase_boundary) {
	$phrase_boundary = ' '; #区切り文字が無かったら半角スペース
    }

    my @tmp = split /$query_boundary/, $query;
    my $tmp_buf = '';
    foreach my $q (@tmp) {
	$q =~ s/(.+?)\"(.+?)/$1$2/g; # 両端以外の引用符は消す
	if ($q =~ m/^\"(.+)\"$/) { # 右側の二重引用符はpushを保留
	    push @query_arr, $1; # 両端が引用符ならpush
	}
	elsif ($q =~ m/^\"(.+)$/) { # 右側の二重引用符はpushを保留
	    $tmp_buf .= $1;
	}
	elsif ($q =~ m/(.+)\"$/) { # 左側の二重引用符はpush
	    $tmp_buf .= "$phrase_boundary".$1;
	    push @query_arr, $tmp_buf;
	    $tmp_buf = '';
	}
	else {
	    if ($tmp_buf ne '') { # 一度保留したら左側の二重引用符が出るまでpushを保留
		$tmp_buf .= $phrase_boundary.$q;
	    }
	    else {
		push @query_arr, $q; # 何も無ければpush
	    }
	}    }
    if ($tmp_buf) {
	push @query_arr, $tmp_buf; # 保留したクエリが残っていたらpush
	$tmp_buf = '';
    }
    return \@query_arr;
}

#print Dump &aka_get_query_arr("1234");
#print Dump &aka_get_query_arr("1234 5678");
#print Dump &aka_get_query_arr("1234 5678 \"9 0\"");
#print Dump &aka_get_query_arr("1234 \"5678 9 0");
#print Dump &aka_get_query_arr("1234::5678", '::');
#print Dump &aka_get_query_arr("1234 hou,\"\"567\"8 9 0\",hou", ",", "---");

1;

