#!/usr/bin/perl
use strict;
use warnings;
use YAML;
use Carp; 
use List::Util qw< sum >;
use Statistics::Distributions qw< chisqrprob >;
use GD::Graph::bars;
use GD::Graph::Data;
use Getopt::Long;

print <<'WELCOME';   
             -R-  
   [+] - RANDOMNESS - [+]

Note: Can be used for checking randomness of any values on chromosomes
License: Creative Commons Licence
Bug-reports and requests to: 
jitendra.narayanATunamur.be
-------------------------------------------------------------------
perl finalChiTest.pl -c renamedAdinetaV2.fa.fai -g extractedAliensCors -l 100000 -p 0 -s 100000 -m gene -p 1 -f 15 > aaaaaa
-------------------------------------------------------------------
WELCOME

my (
	$chrfile,
	$genefile, 
	$bin,
	$size,
	$mode,
	$finicalgene,
	$plot,
	$logfile,
);

my $VERSION = 0.1;
my $verbose = 0; 	# Verbose set to 0;
my %options = ();
my %allChiScore;
$plot=0; #default no plot

GetOptions(
	\%options,
    	'chrfile|c=s'    	=> \$chrfile,        	## Infile
    	'genefile|g=s' 		=> \$genefile,           ## Outfile
	'bin|l=i' 		=> \$bin,		## Size of sub-string
	'size|s=i' 		=> \$size,		## Size of sub-string
	'mode|m=s' 		=> \$mode,		## Size of sub-string
	'plot|p=i' 		=> \$plot,		## Size of sub-string
	'finicalgene|f=i' 	=> \$finicalgene,	## minimum number of gene to consider 
    	'help|?|h!'     	=> sub { RWelcome($VERSION) },
   	'who|w!'     		=> sub { RWho($VERSION) },
	'verbose' 		=> \$verbose,
    	'logfile=s' 		=> \$logfile,		## logfile
	
) or die 'cannot help';

if ((!$chrfile) or (!$genefile) or (!$bin) or(!$size) or (!$mode) or (!$finicalgene)) { print "Missing some commands!!!\n"; exit; }

#Create a DIR to store all the plotted graphs
mkdir("plotted"); 

my $chrFH=read_fh($chrfile);
while (<$chrFH>){
my ($chr, $chrsize) = split;
next if $chrsize <= $size;
	my $geneFH=read_fh($genefile);
	my %count; my $gino=1;
	while (<$geneFH>) {
    		my ($text, $na, $gene, $count) = split;
    		next if $chr ne $text;
    		next unless $gene =~ /$mode/;
    		$count{int($count / $bin)}++;
		$gino++;
	}
	#Add the black 0 if no hits for a range found
	my @allKeys = sort {$a <=> $b} keys %count;
	for (my $aa=0; $aa <= $chrsize/$bin; $aa++) {
    		$count{$aa}=0 unless grep { $aa == $_ } @allKeys;
	}

	my @allVal; my @k;
	for my $key (sort {$a <=> $b} keys %count) {
    		push @allVal, $count{$key};
    		push @k, $key;
	}
next if $gino <= $finicalgene; # Check the humber of genes
my $number=$gino/scalar(@allVal);
my $chiVal = chi_squared_test(
  observed => [ @allVal],
  expected => [ ($number) x scalar(@allVal) ]
);

#print "$chiVal\n";
$allChiScore{$chr}=$chiVal;
if ($plot) {printBar(\@k, \@allVal, $chr, $bin, $mode);}
close $geneFH;
undef %count; undef @allVal; undef @k;
}

for my $k (sort {$a cmp $b} keys %allChiScore) {
    	print "$k\t$allChiScore{$k}\n";
	}

#All subs here ---

#Read the files
sub read_fh {
    my $filename = shift @_;
    my $filehandle;
    if ($filename =~ /gz$/) {
        open $filehandle, "gunzip -dc $filename |" or die $!;
    }
    else {
        open $filehandle, "<$filename" or die $!;
    }
    return $filehandle;
}

#Calculate the chi test
sub chi_squared_test {
    my %arg_for = @_;
    my $observed = $arg_for{observed} 
      // croak q(Argument "observed" required);
    my $expected = $arg_for{expected}
      // croak q(Argument "expected" required);

    @$observed == @$expected or croak q(Input arrays must have same length);

    my $chi_squared = sum map { 
        ( $observed->[$_] - $expected->[$_] )**2 / $expected->[$_]
    } 0 .. $#$observed;

    my $degrees_of_freedom = @$observed - 1;
    my $probability        = chisqrprob(
        $degrees_of_freedom,
        $chi_squared
    );

    return $probability;
}

#Print the bar graph
sub printBar {
my ($key_ref, $val_ref, $chr, $bin, $mode)=@_;
my @k=@$key_ref; my @allVal=@$val_ref;
my $data= [[@k],[@allVal]];
my $graph = GD::Graph::bars->new;
$graph->set( 
    x_label         => "X Label bin $bin",
    y_label         => "Y label $mode count",
    title           => 'A Simple Distributation Bar Chart',
    #y_max_value     => 7,
    #y_tick_number   => 8,
    #y_label_skip    => 3,
    #x_labels_vertical => 1,
    #bar_spacing     => 10,
    #shadow_depth    => 4,
    #shadowclr       => 'dred',
    #transparent     => 0,
) or die $graph->error;
 
$graph->plot($data) or die $graph->error;
my $file = "plotted/bars_$chr.png";
open(my $out, '>', $file) or die "Cannot open '$file' for write: $!";
binmode $out;
print $out $graph->gd->png;
close $out;
}


sub RWelcome {
my $VERSION = shift;
print "\nWelcome to Randomness estimation, version $VERSION\n"; 
}

sub RWho {
my $VERSION = shift;
print "\nJitendra Narayan\n"; 
}
__END__
