#!/usr/bin/env perl

use strict;
use warnings;

use Coro;

sub printit {
    my ($string) = @_;
    cede;
    print $string;
}

async { printit "Hello, " };
async { printit "World!\n" };

cede; cede; # do it
