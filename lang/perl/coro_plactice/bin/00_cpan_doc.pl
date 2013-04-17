#!/usr/bin/env perl

use strict;
use warnings;

use Coro;

async {
    print "hello\n";
};

cede;
