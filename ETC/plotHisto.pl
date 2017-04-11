#!/usr/bin/perl

use strict;
use warnings;
use GD::Graph::histogram;

my @keys = (100, 200, 300);

my $graph = new GD::Graph::histogram(800,600);
$graph -> set(
    x_label => 'Hash Keys',
    y_label => 'count of keys in file',
    title => 'Key count histogram',
    x_labels_vertical => 1,
    bar_spacing => 0,
    shadow_depth => 1,
    shadowclr => 'dred',
    transparent => 0,
)
or warn $graph->error;

my $gd = $graph->plot(\@keys) or die $graph->error;
open(IMG, '>histo.png') or die $!;
binmode IMG;
print IMG $gd->png;
