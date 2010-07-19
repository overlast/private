#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use FindBin::libs;
use Perl6::Say;
use Path::Class qw/dir/;

use Akamon::Index;
use Akamon::Document;

use YAML;

my $pathbase = $FindBin::Bin;
my $doc_dir = "$pathbase/../db";
my $indexfile = 'address7golomb20000.luxio';
my $index_path  = $pathbase."/../".$indexfile;

my @doc_id_arr;
my $dh = dir($doc_dir)->open();

while (my $doc_id = $dh->read()) {
    unless ($doc_id  =~ m|^\d+$|) {
	next;
    }
    push @doc_id_arr, $doc_id;
}

$dh->close();

@doc_id_arr  =  sort {$a <=> $b} @doc_id_arr;

#print Dump \@doc_id_arr;

my %conf_hash  =  (
		   "ngram" => [7,],
		   "pos_coding" => 'golomb',
		   "M" => 20000
		  );
my $conf = \%conf_hash;

my $index = Akamon::Index->new();
foreach my $doc_id (@doc_id_arr) {
    print "[docid]:$doc_id\n";
    my $doc = Akamon::Document->aka_load_document_from_id($doc_dir, $doc_id);
#    print Dump $doc;
    $index->aka_add_document($index_path, $doc, $conf);
}
