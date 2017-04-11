#! perl -slw
use strict;
use vars qw[ $X $Y $N $D ];
use GD;

$|=1;

#use constant { SEED => 0, A => 65537, C => 65539, M => 65536 }; # Really BAD!!
#use constant { SEED => 0, A => 32717, C => 32719, M => 65536 }; # Bad enough!!

my $rnd = 'SEED'; sub badRnd{ $rnd = ('A' * $rnd + 'C') % 'M'; $rnd % $_[0] }

$X ||= 1024; $Y ||= 1024; $N ||= 100_000_000; $D ||= 10;

GD::Image->trueColor( 1 );
my $img = GD::Image->new( $X, $Y );
my $color =0;
my $incr = 1;

$img->fill( 0, 0, 0xffffff );

for( 0 .. $N ) {
#	my( $x, $y ) = ( int badRnd( $X ), int badRnd( $Y ) );
#	printf "[$x:$y] ";
	my( $x, $y ) = ( int rand( $X ), int rand( $Y ) );
	$img->setPixel( $x, $y,  $img->getPixel( $x, $y ) + 1 );
	printf "\r$_   " unless $_ % (1000);
	display() unless $_ % ($X * $Y * $D);
}

sub display {
	open IMG, '>plot.png' or die $!;
	binmode IMG;
	print IMG $img->png;
	close IMG;
	system( 'start /b plot.png' );
}
