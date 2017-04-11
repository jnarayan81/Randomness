use Carp; 
use List::Util qw< sum >;
use Statistics::Distributions qw< chisqrprob >;
use GD::Graph::histogram;

sub chi_squared_test {
    my %arg_for = @_;
    my $observed = $arg_for{observed} 
      // croak q(Argument "observed" required);
    my $expected = $arg_for{expected}
      // croak q(Argument "expected" required);
print "@$observed == @$expected -----\n";
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

print chi_squared_test(
  observed => [ 10, 0, 10, 10, 10, 10],
  expected => [ (10) x 6 ]
);


__END__
sub roll_dice {
    my $arg_for = shift;

    my $sides = $arg_for->{sides} || 6;
    my $times = $arg_for->{times} || 1;

    # we could have also chosen to croak() or throw an exception here
    $sides = 6 if $sides < 2;
    $times = 1 if $times < 1;

    return sum( map { 1 + int rand $sides } 1 .. $times );  # fixed!
}

