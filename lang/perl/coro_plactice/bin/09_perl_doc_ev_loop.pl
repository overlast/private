#!/usr/bin/env perl

use strict;
use warnings;

use EV;
use Coro;
use Coro::Debug;

my $shell = new_unix_server Coro::Debug "/tmp/myshell";

EV::loop; # and loop

=pod
run and try in other terminal window.

$ socat readline /tmp/myshell
=cut
