package Akamon::Document;

use strict;
use warnings;
use utf8;

use FindBin;

use Akamon::DocID;
use Path::Class qw/file/;
use Encode qw/decode_utf8 encode_utf8/;

use base qw/Class::Accessor::Lvalue::Fast/;
__PACKAGE__->mk_accessors(qw/key value doc_id score/);

use YAML;

# dir の分割用の設定
# doc の削除サブルーチンとスクリプト

sub aka_load_document_from_id {
    my ($self, $doc_id_dir, $doc_id) = @_; 
    return $self->aka_load_document($doc_id_dir, $doc_id);
}

sub aka_save_document {
    my ($self, $doc_id_dir, $doc_id_file_name) = @_;
    
    my $docid = Akamon::DocID->new("$doc_id_dir/$doc_id_file_name");
    $self->doc_id = $docid->aka_increment_id();
    
    # valueの格納
    my $fh = file(sprintf ("$doc_id_dir/%d", $self->doc_id))->openw();
    my $key = $self->key;
    my $value = $self->value;

    $key = encode_utf8($key) if utf8::is_utf8($key);
    $value = encode_utf8($value) if utf8::is_utf8($value);

    $fh->print(encode_utf8($self->key));
    $fh->print("\n");
    $fh->print(encode_utf8($self->value));
    $fh->print("\n");
    $fh->close();
    
    $docid->aka_save_id();
    return $self->doc_id;
}

sub aka_load_document {
    my ($self, $doc_id_dir, $doc_id) = @_;

    my $fh = file(sprintf "$doc_id_dir/%d", $doc_id)->openr;

    my $doc = Akamon::Document->new();
    my $key = $fh->getline;
    my $value = $fh->getline;

    $fh->close();
    
    chomp ($key, $value);

    $key = decode_utf8($key) unless utf8::is_utf8($key);
    $value = decode_utf8($value) unless utf8::is_utf8($value);
    
    $doc->{doc_id} = $doc_id;
    $doc->{key} = $key;
    $doc->{value} = $value;

    return $doc;
}


1;

