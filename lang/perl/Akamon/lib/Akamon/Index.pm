package Akamon::Index;

use strict;
use warnings;
use utf8;

use Lux::IO;
use Lux::IO::Btree;
use YAML;

use Akamon::Util qw/aka_get_ngram_arr_ref/;
use Akamon::Document;
use Akamon::Data qw/encode_posting_list encode_posting_list_arr decode_posting_list decode_posting_list_arr/;

use base qw/Class::Accessor::Lvalue::Fast/;
__PACKAGE__->mk_accessors(qw/index/);

use Encode qw/decode_utf8 encode_utf8/;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->index = {};
    return $self;
}
my $encoding = 'vb';

use FindBin;
my $pathbase = $FindBin::Bin;
my $doc_dir  =  "$pathbase/../db";

sub aka_retrieve_document {
  my ($self, $index_path, $query_arr_ref, $mutch_mode, $index_type, $conf) = @_;
  
  my $doc_id_arr_ref = $self->aka_retrieve($index_path, $query_arr_ref, $mutch_mode, $index_type, $conf);
  print "[aka_retrieve_document]\n";
  print Dump $doc_id_arr_ref;
  
  my @document_arr;
  if (($doc_id_arr_ref) && (ref $doc_id_arr_ref eq 'ARRAY')) {
#      print Dump $doc_id_arr_ref;
      foreach my $doc_id (@{$doc_id_arr_ref}) {
	#  print Dump $doc_id;
	  my $doc = Akamon::Document->aka_load_document_from_id($doc_dir, $doc_id);
	  push @document_arr, $doc;
#	  print Dump $doc;
      }
  }
  return \@document_arr;
}

sub aka_retrieve {
  my ($self, $index_path, $query_arr_ref, $mutch_mode, $index_type, $conf) = @_;

  my $btree = Lux::IO::Btree->new(Lux::IO::NONCLUSTER);

=pod

Lux::IO::DB_RDONLY
Lux::IO::DB_RDWR
Lux::IO::DB_CREAT
Lux::IO::DB_TRUNC

=cut

  $btree->open($index_path, Lux::IO::DB_RDONLY);

  
  my @postings;
  my %occur_check_hash;
  foreach my $q (@{$query_arr_ref}) {
      foreach my $N (@{$conf->{ngram}}) {
	  print "\n[ngram num @ Index.pm : ".encode_utf8($N)."]\n"; #comment for debug
	  my $ngram_arr_ref = aka_get_ngram_arr_ref($q, $N);
	  foreach my $ngram (@{$ngram_arr_ref}) {
	      my $result_ref = $btree->get($ngram);
	      if ($result_ref) {
		  print "\n[responce from luxio @ Index.pm : ".$ngram."]\n"; #comment for debug
#		  print Dump $result_ref;
		  my $tmp_arr_ref = decode_posting_list_arr($result_ref, $encoding, $conf);
#		  print Dump $result_ref;
		  #my @tmp_arr = split /\,/, $result_ref;
		  
		  # 本当は頻度も数えた方が良いですね。
		  
		  foreach my $doc_id (@{$tmp_arr_ref}) {
		      if (!(exists $occur_check_hash{$doc_id})) {
			  push @postings, $doc_id;
			  $occur_check_hash{$doc_id} = 1;
		      }
		      else {
			  $occur_check_hash{$doc_id}++;
		      }
		  }
	      }
	      else {
	      }
	  }
      }
  }

  $btree->close;
#  print Dump \@postings;
  return \@postings;

}

sub aka_index_document {
    my ($self, $index_path, $term, $doc_id, $conf) = @_;

    my $btree = Lux::IO::Btree->new(Lux::IO::NONCLUSTER);

    if (-f $index_path) {
	$btree->open($index_path, Lux::IO::DB_RDWR);
    }
    else {
	$btree->open($index_path, Lux::IO::DB_CREAT);
    }

    
    $term = encode_utf8($term) if utf8::is_utf8($term);
#    print Dump $term;
    my $result_ref = $btree->get($term);

    if ((defined $result_ref) && ($result_ref ne "") && ($result_ref ne "~")) {
#	my @tmp_doc_id_arr = split /\,/, $result_ref;
#	push @tmp_doc_id_arr, $doc_id;
#	print "[ref] $result_ref";
	my $doc_id_list = decode_posting_list($result_ref, $encoding, $conf).','.$doc_id;
#	print Dump $doc_id_list;

=pod
	@tmp_doc_id_arr = sort {$a <=> $b} @tmp_doc_id_arr;
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
=cut

#	print Dump \@doc_id_arr;
#	my $doc_id_list = join "\,", @doc_id_arr;
#	print Dump $doc_id_list;
#	

	my $compressed_list = encode_posting_list($doc_id_list, $encoding, $conf);

	$btree->del($term);
#	sleep(1);
#	print Dump $btree->get($term);
#	sleep(1);
#	$btree->put($term, $doc_id_list, Lux::IO::OVERWRITE);
	$btree->put($term, $compressed_list);
#	print "kakunin\n";
#	print Dump decode_posting_list($btree->get($term), $encoding);
#	sleep(1);
    }
    else {
#	print Dump $doc_id;
	my $compressed_list = encode_posting_list($doc_id, $encoding, $conf);
#	print "kakunin mae\n";
#	print Dump $compressed_list;
#	$btree->del($term);
	$btree->put($term, $compressed_list);
#	print "kakunin\n";
#	print Dump $btree->get($term);
#	print Dump decode_posting_list($btree->get($term), $encoding);
    }
    $btree->close;
}

sub aka_add_document {
    my ($self, $index_path, $doc, $conf)  =  @_;
    my @term_arr;
    foreach my $N (@{$conf->{ngram}}) {
	my @tmp  = @{ aka_get_ngram_arr_ref($doc->key, $N)};
	@term_arr  = (@term_arr, @tmp);
	@tmp  = @{ aka_get_ngram_arr_ref($doc->value, $N)};
	@term_arr  = (@term_arr, @tmp);
    }
#    print Dump @term_arr;
    
    my %ngram_count_hash;
    # 出現頻度を含めたいから、近く、このへんを工夫する
    foreach my $term (@term_arr) {
	if (!(exists $ngram_count_hash{$term})) {
	    $self->aka_index_document($index_path, $term, $doc->{doc_id}, $conf);
	    $ngram_count_hash{$term} = 1;
	}
	else {
	    $ngram_count_hash{$term}++;
	}
    }
}

1;

