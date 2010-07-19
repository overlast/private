package Akamon::Data;

use strict;
use warnings;
use utf8;

use Exporter::Lite;
our @EXPORT_OK = qw/encode_posting_list encode_posting_list_arr decode_posting_list decode_posting_list_arr/;
use YAML;

sub culc_length {
    my ($num) = @_;
    my $i = 0;
    for ($i = 0; $num >= 2; $i++) {
	$num = int($num / 2);
    }
    return $i;
}

sub get_length_code {
    my ($num) = @_;
    my $length = "";
    for (my $i = 0; $i < $num; $i++) {
	$length .= '1';
    }
    $length .= '0';
    return $length;
}

sub decimal2binary {
    my ($num) = @_;
    my $binary  = '';
    while ($num > 0) {
	my $tmp = $num % 2;
	$binary = "$tmp$binary";
	$num = int($num / 2);
    }
    return $binary;
}

sub binary2decimal {
    my ($num) = @_;
    my $decimal  = 0;
#    print "[binary] $num\n";
    my $length = length $num;
    my $count = 0;
    for (my $i = $length - 1; $i >= 0 ;$i--) {
	my $bit = substr($num, $i, 1);
#	print "[bit] $bit\n";
#	print "[count] $count\n";
	if ($bit == 1) {
	    $decimal += 2 ** $count;
	}
	else {
#	    $decimal += 0;
	}
	$count++;
    }
 #   print "[decimal] $decimal\n";
    return $decimal;
}

sub get_offset_code {
    my ($num, $code_len) = @_;
    my $offset = "";
    $offset = &decimal2binary($num);
    my $len = ($code_len - 1) - (length $offset);
    for (my $i = $len; $i > 0; $i--) {
	$offset = '0'.$offset;
    }
    return $offset;
}

sub get_gamma_code {
    my ($num) = @_;
    my $length =  &culc_length($num);
 #   print "[gamma num] $num\n";
    my $code = &get_length_code($length);
 #   print "[gamma length code] $code\n";
    if ($num > 0) {
	my $amari = $num - (2 ** $length);
	$code .= &get_offset_code($amari, length $code);
    }
 #   print "[gamma] $code\n";
    return $code;
}

sub encode_gamma {
    my ($list_arr_ref) = @_;
    my $encoded = "";
    my $buffer = "";
    my $count = 0;  

    foreach my $num (@{$list_arr_ref}) {
	my $code = &get_gamma_code($num);

	for (my $i = 0; $i < (length $code); $i++) {
	    vec($buffer, $count++, 1) = substr($code, $i, 1);
	}
    }

    if (my $piece = $count % 8) {
	my $tmpcount = 8 - ($piece); #byteの端数を処理
	for (my $j = 0; $j < $tmpcount; $j++) {
	    vec($buffer, $count++, 1) = 1;
	}
    }

    $encoded .= $buffer;
    return $encoded;
}

sub encode_delta {
    my ($list_arr_ref) = @_;
    my $encoded = "";
    my $buffer = "";
    my $count = 0;  

    foreach my $num (@{$list_arr_ref}) {
#	print "[num] $num\n";
	my $binary = &decimal2binary($num);
#	print "[binary] $binary\n";
	my $length = length $binary;
#	print "[len] $length\n";
	my $code;
	if ($length > 1) {
	    $code = &get_gamma_code($length);
#	    print "[gamma] $code\n";
#	    my $amari = $num - (2 ** $length);
	    $code .= substr($binary, 1, ($length - 1)); 
	    #get_offset_code($amari, length $code);
	}
	else {
	    $code = 0;
	}

#	print "[delta] $code\n";
	for (my $i = 0; $i < (length $code); $i++) {
	    vec($buffer, $count++, 1) = substr($code, $i, 1);
	}
    }

    if (my $piece = $count % 8) {
	my $tmpcount = 8 - ($piece); #byteの端数を処理
	for (my $j = 0; $j < $tmpcount; $j++) {
	    vec($buffer, $count++, 1) = 1;
	}
    }

    $encoded .= $buffer;
    return $encoded;
}

sub get_length_val {
    my ($length) = @_;
    my $length_val = 2 ** $length;
    return $length_val;
}

sub get_offset_val {
    my ($offset_code) = @_;
    my $offset_val = 0;
    my $count = 0;
    for (my $i = ((length $offset_code) - 1); $i >=  0; $i--) {
	my $bit = substr($offset_code, $i, 1);
	if ($bit) {
	    $offset_val += (2 ** $count);
	}
	$count++;
    }
    return $offset_val;
}

sub decode_gamma {
    my ($encoded) = @_;
    my @list_arr;

    my $count = 0;
    my $gamma = unpack("b*", $encoded);

#    print Dump $gamma;
    my $is_length = 1;
    my $length = 0;
    my $gap = 0;
    for (my $i = 0; $i < (length $gamma); $i++) {
	if ($is_length) {
	    my $bit = substr($gamma, $i, 1);
	    #print "[len bit] $bit\n";
	    if ($bit == 1) {
		$length++;
	    }
	    else {
		if ($length) {
		    my $length_val = &get_length_val($length);
		    $gap = $length_val;
		    $is_length = 0;
		}
		else {
		    push @list_arr, 1;
		    #print "[of push] 1\n";
		    $length  =  0;
		    $gap  =  0;
		}
	    }
	}
	else {
	    my $bit = substr($gamma, $i, $length);
	    $i = $i + $length - 1;
	    #print "[off bit] $bit\n";
	    my $offset_val = &get_offset_val($bit);
	    $gap += $offset_val;
	    push @list_arr, $gap;
	    #print "[off push] $gap\n";
	    $length  =  0;
	    $gap  =  0;
	    $is_length = 1;
	}
    }
    return \@list_arr;
}

sub decode_delta {
    my ($encoded) = @_;
    my @list_arr;

    my $count = 0;
    my $delta = unpack("b*", $encoded);

#    print Dump $delta;
    my $is_length = 1;
    my $length = 0;
    my $gap = 0;
    for (my $i = 0; $i < (length $delta); $i++) {
	if ($is_length) {
	    my $bit = substr($delta, $i, 1);
#	    print "[len bit] $bit\n";
	    if ($bit == 1) {
		$length++;
	    }
	    else {
		if ($length) {
		    my $length_val = &get_length_val($length);
		    $gap = $length_val;
		    $is_length = 0;
		}
		else {
		    push @list_arr, 1;
#		    print "[off push] 1\n";
		    $length  =  0;
		    $gap  =  0;
		}
	    }
	}
	else {
	    my $bit = substr($delta, $i, $length);
#	    print "[i] $i\n";
	    $i = $i + $length ;
#	    print "[off bit] $bit\n";
	    my $offset_val = &get_offset_val($bit);
	    $gap += $offset_val;
#	    print "[off gap] $gap\n";
	    my $bit_num = $gap - 1;
#	    print "[off bit_num] $bit_num\n";
	    if ($bit_num) {
		my $gamma_suf_bit = substr($delta, $i, $bit_num);
#		print "[i] $i\n";
#		print "[gamma_suf_bit] $gamma_suf_bit\n";
		$i = $i + $bit_num - 1;
		$gamma_suf_bit = '1'.$gamma_suf_bit;
		$gap =  &binary2decimal($gamma_suf_bit);
	    }
	    else {
	    }
	    
	    push @list_arr, $gap;
#	    print "[off push] $gap\n";

	    $length  =  0;
	    $gap  =  0;
	    $is_length = 1;
	}
    }
    return \@list_arr;
}

sub log2 {
  my ($num) = @_;
  return log($num) / log(2);
}

sub judge_order_of_n {
    my ($n, $bottom, $count_ref) = @_;
    my $is_order = 0;
    for (my $i = 0; $n < ($i ** ${$count_ref}) ; $i++ ) {
	${$count_ref}++;
    }
    if ($n == ($bottom ** ${$count_ref}) ) {
	$is_order = 1;
    }
    result $is_order;
}

sub get_truncated_binary_code {
    my ($num, $c,  $offset_width) = @_;
    my $code = '';
    
    if ($num < $offset_width) {
	$code = &decimal2binary($num); #そのまま decimal2binary
	while ((length $code) < ($c - 1)) {
	    $code = '0'.$code;# bit幅を1減らす, $c-1幅になるようにする。
	}
    }
    else {
	$code = &decimal2binary($num + $offset_width); # $num + $offset_widthを decimal2binary
	while ((length $code) < $c) {
	    $code = '0'.$code;# bitそのまま $c幅になるようにする。
	}
    }
    
    return $code;
}

sub ceil {
  my ($num) = @_;
  my $ceiler = 0;
  if(($num > 0) && ($num != int($num))) {
      $ceiler = 1;
  }
  return int($num + $ceiler);
}

sub encode_golomb {
    my ($list_arr_ref, $M) = @_;
    my $encoded = "";
    my $buffer = "";
    my $count = 0;

#    print "golomb!! \n";
    if ($M > 0) {
	my $order_count = 0;
	#my $is_order_n = &judge_order_of_n($M, 2, \$order_count);
	my $c = &ceil(log2($M)); # これが基本のbit長
	my $offset_width = (2 ** $c) - $M; #これ以下は

#	print "M : $M, c : $c, offset : $offset_width\n";
	foreach my $N (@{$list_arr_ref}) {
	    my $q = int(($N - 1) / $M);
	    my $r = int(($N - 1) - ($q * $M));
#	    print "q : $q, r : $r\n";
	    my $left_code = &get_unary_code($q, 0);
#	    print "left : $left_code\n";
	    my $right_code = '';
	    if ( $offset_width > 0) {
		$right_code = &get_truncated_binary_code($r, $c, $offset_width);
#		print "right : $right_code\n";
	    }
	    else {
		$right_code = &decimal2binary($r); # 右辺をそのまま
		while ((length $right_code) < $c) {
		    $right_code = '0'.$right_code;# bit幅がCより小さいときは足す。
		}
#		print "right : $right_code\n";
	    }

	    my $code = $left_code.$right_code;
#	    print Dump [$N, $code];
	    for (my $i = 0; $i < (length $code); $i++) {
		vec($buffer, $count++, 1) = substr($code, $i, 1);
	    }
	}
    }

    if (my $piece = $count % 8) {
	my $tmpcount = 8 - ($piece); #byteの端数を処理
	for (my $j = 0; $j < $tmpcount; $j++) {
	    vec($buffer, $count++, 1) = 1; # 1じゃ駄目かもよ
	}
    }

    $encoded .= $buffer;
    return $encoded;
}

sub decode_golomb {
    my ($encoded, $M) = @_;
    my @list_arr;

    my $count = 0;
    my $golomb = unpack("b*", $encoded);

#    print "[decode golomb]\n";
#    print Dump $golomb;

    my $c = &ceil(log2($M)); # これが基本のbit長
    my $offset_width = (2 ** $c) - $M; #これ以下は
#    print "M : $M, c : $c, offset : $offset_width\n";
    my $is_left = 1;
    my $q = 0; #unaryの初期値
    for (my $i = 0; $i < (length $golomb); $i++) {
	my $bit = substr($golomb, $i, 1);
	if ($is_left) {
#	    print "[unary bit] $bit\n";
	    if ($bit > 0) {
		$q++; #unary 符号を戻す。
	    }
	    else {
		$is_left = 0;
	    }
	}
	else {
	    my $gap = '';
	    if ( $offset_width > 0 ) {
		$bit = substr($golomb, $i, $c - 1);
		$i = $i + $c - 2;
#		print "[bit] $bit\n";
		my $r = binary2decimal($bit);
		if ($r >= $offset_width) {
		    $i++;
		    $bit .= substr($golomb, $i, 1);
		    $r = binary2decimal($bit);
#		    print "[bit] $bit\n";
#		    print "q : $q, r : $r\n";
		    $gap = ($q * $M) + $r + 1; #初期値が1
		    $gap = $gap - $offset_width;
#		    print Dump $gap;
		}
		else {
#		    print "[bit] $bit\n";
#		    print "q : $q, r : $r\n";
		    $gap = ($q * $M) + $r + 1; #初期値が1
#		    print Dump $gap;
		}

		$is_left = 1;
		$q = 0;
	    }
	    else {
		$bit = substr($golomb, $i, $c);
		$i = $i + $c - 1;
#		print "[bit] $bit\n";
		my $r = binary2decimal($bit);
#		print "q : $q, r : $r\n";
		$gap = ($q * $M) + $r + 1; #初期値が1
#		print Dump $gap;
#		push @list_arr, $gap;
		$is_left = 1;
		$q = 0;
	    }
	    push @list_arr, $gap;
	}
    }
    return \@list_arr;
}

sub encode_interpolative {
    my ($list_arr_ref, $f, $low, $high) = @_;
    my $encoded = "";
    my $buffer = "";
    my $count = 0;
    
    


=pod

#    print "golomb!! \n";
    if ($M > 0) {
	my $order_count = 0;
	#my $is_order_n = &judge_order_of_n($M, 2, \$order_count);
	my $c = &ceil(log2($M)); # これが基本のbit長
	my $offset_width = (2 ** $c) - $M; #これ以下は

#	print "M : $M, c : $c, offset : $offset_width\n";
	foreach my $N (@{$list_arr_ref}) {
	    my $q = int(($N - 1) / $M);
	    my $r = int(($N - 1) - ($q * $M));
#	    print "q : $q, r : $r\n";
	    my $left_code = &get_unary_code($q, 0);
#	    print "left : $left_code\n";
	    my $right_code = '';
	    if ( $offset_width > 0) {
		$right_code = &get_truncated_binary_code($r, $c, $offset_width);
#		print "right : $right_code\n";
	    }
	    else {
		$right_code = &decimal2binary($r); # 右辺をそのまま
		while ((length $right_code) < $c) {
		    $right_code = '0'.$right_code;# bit幅がCより小さいときは足す。
		}
#		print "right : $right_code\n";
	    }

	    my $code = $left_code.$right_code;
#	    print Dump [$N, $code];
	    for (my $i = 0; $i < (length $code); $i++) {
		vec($buffer, $count++, 1) = substr($code, $i, 1);
	    }
	}
    }

=cut

    if (my $piece = $count % 8) {
	my $tmpcount = 8 - ($piece); #byteの端数を処理
	for (my $j = 0; $j < $tmpcount; $j++) {
	    vec($buffer, $count++, 1) = 1; # 1じゃ駄目かもよ
	}
    }

    $encoded .= $buffer;
    return $encoded;
}



#my @a = (1,2,3,4,9,13,24,511,1025);
#my @a = (1,2,3,4,5,6,7,8,9,10,11,12,13);
my @a = (3,5,1,2,1,1,4);
my $interpolative = &encode_interpolative(\@a, ($#a + 1), 1, 20);
print Dump $interpolative;


#my $golomb = &encode_golomb(\@a, 8);
#print Dump $golomb;
#my $arr_ref = &decode_golomb($golomb, 8);
#print Dump $arr_ref;

sub get_unary_code {
    my ($num, $start) = @_;
#    print Dump $num;
    unless ((defined $start) && ($start >= 0)) {
	$start = 1;
    }
    my $unary = '';
    for (my $i = $start; $i < $num; $i++) {
	$unary .= '1';
    }
    $unary .= '0';
    return $unary;
}

sub encode_unary {
    my ($list_arr_ref) = @_;
    my $encoded = "";
    my $buffer = "";
    my $count = 0;
    foreach my $num (@{$list_arr_ref}) {
	for (my $i = 1; $i < $num; $i++) {
	    vec($buffer, $count++, 1) = 1;
	}
	vec($buffer, $count++, 1) = 0;
    }

    if (my $piece = $count % 8) {
	my $tmpcount = 8 - ($piece); #byteの端数を処理
	for (my $j = 0; $j < $tmpcount; $j++) {
	    vec($buffer, $count++, 1) = 1;
	}
    }

    $encoded .= $buffer;
    return $encoded;
}

sub get_unary_val {
    my ($unary, $start) = @_;
    unless ((defined $start) && ($start >= 0)) {
	$start = 1;
    }
    my $val = $start;
    for (my $i = 0; $i < (length $unary); $i++) {
	if (substr($unary, $i, 1) eq '1') {
	}
	else {
	    last;
	}
	$val++;
    }
    return $val;
}

sub decode_unary {
    my ($encoded) = @_;
    my @list_arr;

    my $count = 0;
    my $unary = unpack("b*", $encoded);

#    print Dump $unary;
    for (my $i = 0; $i < (length $unary); $i++) {
	$count++;
	if (substr($unary, $i, 1) eq '1') {
	}
	else {
	    push @list_arr, $count;
	    $count = 0;
	}
    }
    
 #   print "unary kakunin\n";
#    print Dump \@list_arr;

    return \@list_arr;
}

sub compress {
    my ($list_arr_ref, $mode, $param_ref) = @_;
    my $compressed;
    if ($mode eq 'vb') {
#	print Dump "compress\n",$list_arr_ref;
	$compressed = pack('w*', @{$list_arr_ref});
    }
    elsif ($mode eq 'unary') {
	$compressed = &encode_unary($list_arr_ref);
    }
    elsif ($mode eq 'gamma') {
	$compressed = &encode_gamma($list_arr_ref);
    }
    elsif ($mode eq 'delta') {
	$compressed = &encode_delta($list_arr_ref);
    }
    elsif ($mode eq 'golomb') {
	if ((exists $param_ref->{M}) && ($param_ref->{M} > 0)) {
	}
	else {
	    $param_ref->{M} = 3; #default。要調整
	}
	$compressed = &encode_golomb($list_arr_ref, $param_ref->{M});
    }

    return $compressed;
}

sub decompress {
    my ($compressed, $mode, $param_ref) = @_;
    my @decompressed_arr;
 #   print "decompress\n";
#    print Dump $compressed;

    if ($mode eq 'vb') {
	@decompressed_arr = unpack('w*', $compressed);
    }
    elsif ($mode eq 'unary') {
	@decompressed_arr = @{&decode_unary($compressed)};
    }
    elsif ($mode eq 'gamma') {
	@decompressed_arr = @{&decode_gamma($compressed)};
    }
    elsif ($mode eq 'delta') {
	@decompressed_arr = @{&decode_delta($compressed)};
    }
    elsif ($mode eq 'golomb') {
	if ((exists $param_ref->{M}) && ($param_ref->{M} > 0)) {
	}
	else {
	    $param_ref->{M} = 3; #default。要調整
	}
	@decompressed_arr = @{&decode_golomb($compressed, $param_ref->{M})};
    }

    return \@decompressed_arr;
}

sub encode_gap {
    my ($list_arr_ref) = @_;
#    print "encode gap\n";
#    print Dump $list_arr_ref;
    my $num = $#{$list_arr_ref};
    for (my $i = $num; $i > 0; $i--) {
	$list_arr_ref->[$i] -= $list_arr_ref->[$i - 1];
    }
#    print "encoded gap\n";
#    print Dump $list_arr_ref;
    return $list_arr_ref;
}

sub sort_and_uniq {
    my ($list_arr_ref) = @_;
#    print Dump $list_arr_ref;
    my @tmp_doc_id_arr = sort {$a <=> $b} @{$list_arr_ref};
    my @doc_id_arr = ();
    my %occur_check_hash;
    foreach my $num (@tmp_doc_id_arr) {
	if (exists $occur_check_hash{$num}) {
	}
	else {
	    $occur_check_hash{$num} = 1;
	    push @doc_id_arr,$num;
	}
    }
    return \@doc_id_arr;
}

sub encode_posting_list {
    my ($list, $mode, $param_ref) = @_;
    my $result;
    my @doc_id_arr = split /\,/, $list;
#    print Dump \@doc_id_arr;
    
    if (@doc_id_arr) {
	my $doc_id_arr_ref = &sort_and_uniq(\@doc_id_arr);
#	print Dump $doc_id_arr_ref;

	$result = &compress(&encode_gap($doc_id_arr_ref), $mode, $param_ref);
#	print "unary\n";
#	print Dump $result;
    }
    return $result;
}

sub encode_posting_list_arr {
    my ($list_arr_ref, $mode, $param_ref) = @_;
    my $result;
    if ((ref $list_arr_ref eq 'ARRAY') && (@{$list_arr_ref})) {
	my $doc_id_arr_ref = &sort_and_uniq($list_arr_ref);
	$result = &compress(&encode_gap($doc_id_arr_ref), $mode, $param_ref);
    }
    return $result;
}

sub decode_gap {
    my ($gapped_arr_ref) = @_;
#    print "decode gap\n";#
#    print Dump $gapped_arr_ref;
    my $num = $#{$gapped_arr_ref};
#    print "num";
#    print $num;

    for (my $i = 0; $i < $num; $i++) {
	$gapped_arr_ref->[$i + 1] += $gapped_arr_ref->[$i];
    }
#    print "decoded gap\n";
#    print Dump $gapped_arr_ref;
#    sleep(2);
    return $gapped_arr_ref;
}

sub decode_posting_list {
    my ($compressed, $mode, $param_ref) = @_;
    my $arr_ref = &decompress($compressed, $mode, $param_ref);
    return join "\,", @{&decode_gap($arr_ref)};
}

sub decode_posting_list_arr {
    my ($compressed, $mode, $param_ref) = @_;
 #   print Dump $compressed;
    my $arr_ref = &decompress($compressed, $mode, $param_ref);
    return &decode_gap($arr_ref);
}

#my @a  =  (1, 2, 3, 5, 6,8,9);
#my $uunary = &encode_posting_list_arr(\@a, 'unary');
#print Dump $uunary;

#my $rref =  &decode_posting_list_arr($uunary, 'unary');
#print Dump $rref;

1;

