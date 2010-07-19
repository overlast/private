package Akamon::Util;

use strict;
use warnings;
use utf8;

use Exporter::Lite;
our @EXPORT_OK  = qw/aka_get_ngram_arr_ref/;

use Encode qw/decode_utf8 encode_utf8/;

sub aka_get_ngram_arr_ref {
    my ($str, $N)  =  @_;
    if (!($N) || ($N <= 0)) {
	$N  =  2;
    }
    
    my @result_arr = ();
    my $tmp = $str;
#    $tmp  =  Encode::encode_utf8($tmp);
    $tmp = Encode::decode_utf8($tmp) unless utf8::is_utf8($str);
#    print $tmp."eeeeeee\n";
    # クエリをpush前にencodeすること。
#    $tmp = Encode::decode_utf8($tmp);# unless utf8::is_utf8($str);
  #  utf8::decode($tmp);
    my $str_len = length $tmp;
#    print $str_len."\n";
 #   my $str_len2 = length "あいうえお";
 #   print $str_len2."\n";
    if ($str_len < $N) {
	$str = encode_utf8($str) if utf8::is_utf8($str);
	push @result_arr, $str;
    }
    else {
	for (my $i = 0; $i <= ($str_len - $N); $i++) {
	    my $subs = substr($str, $i, $N);
	    $subs = encode_utf8($subs) if utf8::is_utf8($subs);
	    push @result_arr, $subs;
	}
    }
    return \@result_arr;
}

1;
