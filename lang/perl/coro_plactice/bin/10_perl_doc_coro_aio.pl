#!/usr/bin/env perl

use strict;
use warnings;

use Fcntl;
#use IO::AIO;       # used by Coro::AIO
#use AnyEvent::AIO; # used by Coro::AIO
use Coro::AIO;

my $filename = "coro_aio_test";
my $data = "use Colo::AIO\n";

my $fh = aio_open "$filename~", O_WRONLY | O_CREAT, 0600 or die "$filename~: $!";

aio_write $fh, 0, (length $data), $data, 0;
aio_fsync $fh;
aio_close $fh;
aio_rename "$filename~", "$filename";
