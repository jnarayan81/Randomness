#!/usr/bin/env perl

use strict;
use warnings;

open FILE1, "< $ARGV[0]" or die "could not open file1\n";
my $keyRef;
while (<FILE1>) {
   chomp;
   #$keyRef->{$_} = 1;
   my $name=$_;
   my ($ai, $abc, $gene) = split("\t", $_);
   $gene =~ s/VT/VG/g;
   next if $ai <= 60;

open FILE2, "< $ARGV[1]" or die "could not open file2\n";
while (<FILE2>) {
    chomp;
    my ($testKey, $label, $count) = split("\t", $_);
    #if (defined $keyRef->{$testKey}) {
    if (index($_, $gene) != -1) {
        print STDOUT "$_\n";
    }
}
close FILE2;
}
close FILE1;

