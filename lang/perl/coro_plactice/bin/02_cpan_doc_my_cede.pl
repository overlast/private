#!/usr/bin/env perl

use strict;
use warnings;

use Coro;

sub my_cede {
    $Coro::current->ready;
    schedule;
}

async {
    print "async 1\n";
    my_cede();
    print "async 2\n";
};

print "main 1\n";
my_cede();
print "main 2\n";
my_cede();
