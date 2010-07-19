package Akamon::Search;

use strict;
use warnings;
use utf8;

use FindBin::libs;
use Akamon::Index;
use Akamon::Query;

use YAML;
use Encode qw/encode_utf8/;

# カウントするな追加する時にインクリメントしろ。

sub aka_search_surface_exactmatch {
    my ($self, $index_path, $query, $conf) = @_;
    my $index = Akamon::Index->new();
    
    # クエリのノーマライズをする必要がある。
    # Query.pm か
    my $query_arr_ref = Akamon::Query->aka_get_query_arr($query);
#    print Dump $query_arr_ref;

    # my @result  =  Akamon::Index->retrieve($query);と同じ。
    my $result_arr_ref = Akamon::Index->aka_retrieve_document($index_path, $query_arr_ref, 'exact', 'surface', $conf);
    
    return $result_arr_ref;
}

1;
