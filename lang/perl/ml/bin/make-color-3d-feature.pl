#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use autodie;
use Log::Minimal;
use Pod::Usage;
use YAML;
use JSON;
use Web::Scraper;
use Encode;

&main();

sub main {
    my $input_dir_path = "";
    my $input_file_path = dir($input_dir_path);
    my $output_file_path = "";
    my $data = &read_json($input_file_path);
    my $feature = &make_feature($data);
    if (&store_feature($output_file_path, $feature)) {
    }
    else {
    }
}
