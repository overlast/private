#!/usr/bin/env perl

use strict;
use warnings;

use Coro;

async {
    print "async 1\n";
    cede;
    print "async 2\n";
};

print "main 1\n";
cede;
print "main 2\n";
cede;
