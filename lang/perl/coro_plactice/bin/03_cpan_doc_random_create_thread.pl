#!/usr/bin/env perl

use strict;
use warnings;

use Coro;

my $wakeme = $Coro::current;

async {
    $wakeme->ready if 0.5 > rand;
};

schedule;

=pod
$perl 03_cpan_doc_random_create_thread.pl
FATAL: deadlock detected.
                 PID SC  RSS USES Description              Where
             9720024 -C  19k    0 [main::]                 [03_cpan_doc_random_create_thread.pl:14]
             9880760 UC  14k    1                          [Coro.pm:691]
             9605704 -- 2060    1 [coro manager]           [Coro.pm:691]
             9606376 N-  216    0 [unblock_sub scheduler]  -
=cut
