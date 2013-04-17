#!/usr/bin/env perl

use strict;
use warnings;

use Coro;

my $calculate = new Coro::Channel;
my $result    = new Coro::Channel;

async {
    # endless loop
    while () {
        my $num = $calculate->get; # read a number
        $num **= 2; # square it
        $result->put ($num); # put the result into the result queue
    }
};

for (1, 2, 5, 10, 77) {
    $calculate->put ($_);
    print "$_ ** 2 = ", $result->get, "\n";
}
