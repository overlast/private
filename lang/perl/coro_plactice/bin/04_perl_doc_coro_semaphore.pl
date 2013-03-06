#!/usr/bin/env perl

use strict;
use warnings;

use Coro;

my $sem = new Coro::Semaphore 0; # a locked semaphore

async {
    print "unlocking semaphore\n";
    $sem->up;
};

print "trying to lock semaphore\n";
$sem->down;
print "we got it!\n";
