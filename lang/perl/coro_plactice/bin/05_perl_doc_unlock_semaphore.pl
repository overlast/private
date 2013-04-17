#!/usr/bin/env perl

use strict;
use warnings;

use Coro;
use Coro::AnyEvent;

my $lock = new Coro::Semaphore(1); # unlocked initially - default is 1

sub costly_function {
    my $guard = $lock->guard; # down when begin and up when end
    print "uryyyyyy\n";
}

for (0..10) {
    costly_function();
}
