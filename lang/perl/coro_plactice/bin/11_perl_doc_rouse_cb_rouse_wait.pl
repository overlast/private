#!/usr/bin/env perl

use strict;
use warnings;

use Coro;
use AnyEvent::HTTP;
use YAML;

## do not pass control for long - http_get immediately returns
#http_get "http://www.livedoor.com/", sub {
#    print $_[0];
#};

# do not pass control for long - http_get immediately returns
http_get "http://www.livedoor.com/", Coro::rouse_cb;

# we stay in control and can do other things...
# ...such as wait for the result
my ($res) = Coro::rouse_wait;
print Dump $res;
