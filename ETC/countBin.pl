#!/usr/bin/perl
use strict;
use warnings;
use YAML;

my %count_per_100k;
while (<DATA>) {
    my ($text, $count) = split;
    next unless $text =~ /gene/;
    $count_per_100k{int($count / 100000)}++;
}
print Dump \%count_per_100k;

__DATA__    
gene    3936
gene    7591
gene    13082
gene    23200
gene    32518
gene    45123
gene    57330
gene    62384
gene    66839
gene    71715
gene    83427
gene    90948
gene    87510
gene    96042
gene    106380
gene    108247
gene    109395
gene    120121
gene    138410
gene    143225
gene    147455
gene    152452
gene    155580
gene    158939
gene    163483
gene    167583
gene    178450
gene    181546
gene    184301
gene    193505
gene    190880
gene    199431
gene    202844
