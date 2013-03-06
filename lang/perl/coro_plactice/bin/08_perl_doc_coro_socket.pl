#!/usr/bin/env perl

use strict;
use warnings;

use Coro;
use Coro::Socket;

sub finger {
    my ($user, $host) = @_;

    my $fh = new Coro::Socket PeerHost => $host, PeerPort => "finger"
        or die "$user\@$host: $!";

    print $fh "$user\n";

    print "$user\@$host: $_" while <$fh>;
    print "$user\@$host: done\n";
}

# now finger a few accounts
for (
    (async { finger "abc", "cornell.edu" }),
    (async { finger "sebbo", "world.std.com" }),
    (async { finger "trouble", "noc.dfn.de" }),
) {
    $_->join; # wait for the result
}
