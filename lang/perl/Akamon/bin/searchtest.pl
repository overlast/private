#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin::libs;
use Perl6::Say;

use Akamon::Search;
use Encode qw/encode_utf8 decode_utf8/;
use YAML;


my $pathbase = $FindBin::Bin;
my $indexfile = 'address7golomb20000.luxio';
my $index_path  = $pathbase."/../".$indexfile;
my $doc_dir = "$pathbase/../db";

my @query_arr = ('東京都渋谷区恵比寿西', '横浜市栄区飯島町');

my %conf_hash  =  (
		   ngram => [7,],
		   "pos_coding" => 'golomb',
		   "M" => 20000
		  );

my $conf = \%conf_hash;
#print Dump $conf;

foreach my $q (@query_arr) {
    if ($q) {
	$q = decode_utf8($q) unless utf8::is_utf8($q);
	my $result_arr_ref = Akamon::Search->aka_search_surface_exactmatch($index_path, $q, $conf);
	if (ref $result_arr_ref eq 'ARRAY') {
	    foreach my $doc (@{$result_arr_ref}) {
		say sprintf ("[%d] %s  = > %s", $doc->doc_id, $doc->key, $doc->value);
	    }
	}
	else {
	    $q = encode_utf8($q) if utf8::is_utf8($q);
	    print ("[retrieve -> $q)] no match.\n");
	}
    }
    else {
	print ("[until retrieved] no query to search.\n");
    }
}



