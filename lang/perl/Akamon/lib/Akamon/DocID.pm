package Akamon::DocID;

use strict;
use warnings;
use utf8;

use Path::Class qw/file/;

sub new {
    my ($class, $id_file_path) = @_;
    my $self = bless { id_file_path => $id_file_path };
    return $self;
}

sub aka_get_current_id {
    my ($self)  =  @_;
    my $current_id;
    if (exists $self->{current_id}) {
	$current_id = $self->{current_id};
    }
    else {
	my $fh = file($self->{id_file_path})->open() or return 0;
	my $tmp_current_id = $fh->getline();
	$fh->close();
	chomp $tmp_current_id;
	unless ($tmp_current_id =~ m/^\d+$/) {
	    die 'assert (not a number)\n';
	}
	$current_id = $tmp_current_id;
    }
    return $current_id;
}


sub aka_increment_id {
    my ($self) = @_;
    $self->{current_id} = $self->aka_get_current_id() + 1;
    return $self->{current_id};
}

sub aka_save_id {
    my ($self) = @_;
    unless (-f $self->{id_file_path}) {
	if ($self->{id_file_path} =~ m!^(.+)/+?!) {
	    my $doc_id_dir = $1;
	    system("mkdir -p $doc_id_dir");
	}
    }
    my $fh = file($self->{id_file_path})->openw();
    $fh->print( $self->{current_id} );
    $fh->close();
    return;
}

1;
