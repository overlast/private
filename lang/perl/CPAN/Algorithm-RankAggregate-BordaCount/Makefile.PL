use strict;
use warnings;
use inc::Module::Install;

name 'Algorithm-RankAggregate-BordaCount';
all_from 'lib/Algorithm/RankAggregate/BordaCount.pm';
author 'Toshinori Sato (@overlast) <overlasting {at} gmail.com>';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
