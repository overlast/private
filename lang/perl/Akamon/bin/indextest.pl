#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use FindBin::libs;
use Perl6::Say;
#use Path::Class;
use YAML::Syck;

use Akamon::Document;
use Encode qw/decode_utf8 encode_utf8/;

my $pathbase = $FindBin::Bin;
my $infile = $ARGV[0];
my $infilepath  = $pathbase."/../".$infile;

my $doc_dir = "$pathbase/../db";
my $doc_id_file_name = "doc_id.txt";


unless (-f "$infilepath") {
    die "basefile is not found\n";
}

my $INFILE;
open($INFILE, "< $infilepath") or die "$!";

while (my $l = <$INFILE>) {
    chomp $l;
    
    $l = decode_utf8($l) unless utf8::is_utf8($l);
    
    my @arr = split /\t/, $l;
    unless (@arr) {next;}
    my $kay;
    my $val;
    my $doc = Akamon::Document->new();

    $doc->key = $arr[0];
    if ($arr[1]) {
	$doc->value = $arr[1];
    }
    else {
	$doc->value = $arr[0];
    }
    say $doc->aka_save_document($doc_dir, $doc_id_file_name);

    print Dump \@arr;

}

close($INFILE);
